//uniform float uKa, uKd, uKs;
//uniform float uShininess;

varying vec2 vST;
varying vec3 vN;
varying vec3 vL;
varying vec3 vE;
varying vec3 vMC;

//projectf
uniform float uKa, uKd, uKs;
//uniform vec4 uColor;
//const vec4 uColor = { 1., 1., 100., 1. };
uniform float uShininess;
uniform sampler3D Noise3;
uniform float uNoiseAmp;
uniform float uNoiseFreq;
//const vec4 WHITE = { 1., 1., .8, 1. };

const vec3 uuColor = vec3(0.1, 0.1, 1.);
const vec3 uuWHITE = vec3(1., 1., .8);


const vec3 YELLOW   = vec3(1.0, 1.0, 0.0);
const vec3 DARKGRAY = vec3(0.7, 0.7, 0.7);
const vec3 OBJECTCOLOR      = YELLOW;
const vec3 HATCHINGCOLER    = DARKGRAY;
const vec3 SPECULAR_COLOR = vec3(1.0, 1.0, 1.0);

const float uA = 50.0;
const float uP = 0.4;
const float uTol = 0.03;

//projectf //project3
vec3 RotateNormal( float angx, float angy, vec3 n )
{
    float cx = cos( angx );
    float sx = sin( angx );
    float cy = cos( angy );
    float sy = sin( angy );
    // rotate about x:
    float yp = n.y*cx - n.z*sx; // y'
    n.z = n.y*sx + n.z*cx; // z'
    n.y = yp;
    // n.x = n.x;
    // rotate about y:
    float xp = n.x*cy + n.z*sy; // x'
    n.z = -n.x*sy + n.z*cy; // z'
    n.x = xp;
    // n.y = n.y;
    return normalize( n );
}


void main() {
    vec4 uColor = vec4(uuColor, 1.);
    vec4 WHITE = vec4(uuWHITE, 1.);

    vec4 nvx = texture3D( Noise3, uNoiseFreq*vMC );
    vec4 nvy = texture3D( Noise3, uNoiseFreq*vec3(vMC.xy,vMC.z+0.5) );

    float angx = nvx.r + nvx.g + nvx.b + nvx.a;     // 1. -> 3.
    angx = angx - 2.;  
    // -1. -> 1.
    angx *= uNoiseAmp;
    
    
    float angy = nvy.r + nvy.g + nvy.b + nvy.a;     // 1. -> 3. 
    angy = angy - 2.;
    // -1. -> 1.
    angy *= uNoiseAmp;

    //projectf //vNs, vLs, vEs
    vec3 normal = normalize( vN );
    vec3 light = normalize( vL );
    vec3 eye = normalize( vE );

    normal = RotateNormal( angx, angy, normal );

    vec4 ambient = uKa * uColor;

    float d = max( dot(normal,light), 0. );
    d = abs( dot(normal,light));
    vec4 diffuse = uKd * d * uColor;

    float s = 0.;
    if( dot(normal,light) > 0. ) {          // only do specular if the light can see the point
        vec3 ref = normalize( 2. * normal * dot(normal,light) - light );
        s = pow( max( dot(eye,ref),0. ), uShininess );
    }
    vec4 specular = uKs * s * WHITE;
    gl_FragColor = vec4( ambient.rgb + diffuse.rgb + specular.rgb, 1. );



    /* //project7
    vec3 myColor = hatchingTexture(vST);

    vec3 Normal = normalize(vN);
    vec3 Light  = normalize(vL);
    vec3 Eye    = normalize(vE);

    vec3 ambient = uKa * myColor;

    float d = max(dot(Normal, Light), 0.0);     // only do diffuse if the light can see the point
    vec3 diffuse = uKd * d * myColor;

    float s = 0.0;
    if (d > 0.0) {                              // only do specular if the light can see the point
        vec3 ref = normalize(reflect(-Light, Normal));
        float cosphi = dot(Eye, ref);
        if (cosphi > 0.0) {
            s = pow(max(cosphi, 0.0), uShininess);
        }
    }

    vec3 specular = uKs * s * SPECULAR_COLOR;
    gl_FragColor = vec4(ambient + diffuse + specular, 1.0);
    */
}
