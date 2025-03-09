uniform float uKa, uKd, uKs;
uniform float uShininess;
uniform float uRedDepth, uBlueDepth;

varying vec2 vST;
varying vec3 vN;
varying vec3 vL;
varying vec3 vE;
varying vec3 vMC;

varying float   vZ;

const vec3 YELLOW   = vec3(255., 255., 0.);
const vec3 DARKGRAY = vec3(0.7, 0.7, 0.7);
const vec3 OBJECTCOLOR      = YELLOW;
const vec3 HATCHINGCOLER    = DARKGRAY;
const vec3 SPECULAR_COLOR = vec3(1.0, 1.0, 1.0);

const float uA = 50.0;
const float uP = 0.4;
const float uTol = 0.03;
const bool  uUseChromaDepth = true;
//uniform bool  uUseChromaDepth;

float SmoothPulse(float left, float right, float value, float tol)
{
	return smoothstep(left-tol, left+tol, value) - smoothstep(right-tol, right+tol, value);
}

vec3 hatchingTexture(vec2 st) {
    //int numins = int( st.s / uA );
	//float Sc = (float(numins) * uA) + uA / 2.;

    float r = sqrt( st.s * st.s + st.t * st.t );
    //float rfrac = fract( uA * r );              //rings
    float rfrac = fract( uA * st.s );             //stripes
    float tp = smoothstep( 0.5-uP-uTol, 0.5-uP+uTol, rfrac ) -
                smoothstep( 0.5+uP-uTol, 0.5+uP+uTol, rfrac ); 

	vec3 myColor = mix( HATCHINGCOLER, OBJECTCOLOR, tp );

    return myColor;
}

vec3 Rainbow(float t)
{
        t = clamp( t, 0., 1. );         // 0.00 is red, 0.33 is green, 0.67 is blue

        float r = 1.;
        float g = 0.0;
        float b = 1.  -  6. * ( t - (5./6.) );

        if( t <= (5./6.) )
        {
                r = 6. * ( t - (4./6.) );
                g = 0.;
                b = 1.;
        }

        if( t <= (4./6.) )
        {
                r = 0.;
                g = 1.  -  6. * ( t - (3./6.) );
                b = 1.;
        }

        if( t <= (3./6.) )
        {
                r = 0.;
                g = 1.;
                b = 6. * ( t - (2./6.) );
        }

        if( t <= (2./6.) )
        {
                r = 1.  -  6. * ( t - (1./6.) );
                g = 1.;
                b = 0.;
        }

        if( t <= (1./6.) )
        {
                r = 1.;
                g = 6. * t;
        }

        return vec3( r, g, b );
}

void main() {
    vec3 myColor = hatchingTexture(vST);

    if( uUseChromaDepth )
    {
        float t = (2./3.) * ( abs(vZ) - uRedDepth ) / ( uBlueDepth - uRedDepth );
        t = clamp( t, 0., 2./3. );
        myColor = Rainbow( t );
    }

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
}
