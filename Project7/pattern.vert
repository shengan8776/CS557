varying vec2 vST;   // (s,t) texture coordinates
varying vec3 vN;    // normal vector
varying vec3 vL;    // vector from point to light
varying vec3 vE;    // vector from point to eye
varying vec3 vMC;   // model coordinates

//project7
varying float vX, vY;

uniform float uTime;
uniform float uSquirmFreq, uSquirmAmp;

uniform sampler3D uNoiseTexture;
uniform float uNoiseFreq, uNoiseAmp;

const vec3 LIGHTPOSITION = vec3(5., 5., 0.);

const float PI = 3.14159265;
const float TWOPI = 2.0 * PI;
const float LENGTH = 5.0;   // Scale of the wave

void main()
{
    vec4 nv = texture3D(uNoiseTexture, uNoiseFreq * vec3(vST, 0.));
    float n = nv.r + nv.g + nv.b + nv.a;
    n *= uNoiseAmp;

    // Apply the wave movement with some noise to Z
    vec3 vert = gl_Vertex.xyz;
    //vert.z += n + (uSquirmAmp * sin(TWOPI * uSquirmFreq * uTime + (TWOPI * vert.x) / LENGTH));

    vec3 MCposition = gl_Vertex.xyz; 
    vX = MCposition.x;
    vY = MCposition.y;

    //per-fragment lighting
    vST = gl_MultiTexCoord0.st;
    vMC = gl_Vertex.xyz;
    vec4 ECposition = gl_ModelViewMatrix * vec4(vert, 1.0); // eye coordinate position
    vN = normalize(gl_NormalMatrix * gl_Normal);            // normal vector
    vL = LIGHTPOSITION - ECposition.xyz;                    // vector from the point to the light position
    vE = vec3(0., 0., 0.) - ECposition.xyz;                 // vector from the point to the eye position

    gl_Position = gl_ModelViewProjectionMatrix * vec4(vert, 1.0);
}
