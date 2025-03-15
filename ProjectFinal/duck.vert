varying vec2 vST;   // (s,t) texture coordinates
varying vec3 vN;    // normal vector
varying vec3 vL;    // vector from point to light
varying vec3 vE;    // vector from point to eye
varying vec3 vMC;   // model coordinates

const vec3 LIGHTPOSITION = vec3(5., 5., 0.); //vec3(  8., 1., 3. );
const float PI = 3.14159265;
const float G = 1.;

void main()
{
    vec3 vert = gl_Vertex.xyz;

    //per-fragment lighting
    vST = gl_MultiTexCoord0.st;
    vMC = gl_Vertex.xyz;
    vec4 ECposition = gl_ModelViewMatrix * vec4(vert, 1.0); // eye coordinate position
    vN = normalize(gl_NormalMatrix * gl_Normal);            // normal vector
    vL = LIGHTPOSITION - ECposition.xyz;                    // vector from the point to the light position
    vE = vec3(0., 0., 0.) - ECposition.xyz;                 // vector from the point to the eye position

    gl_Position = gl_ModelViewProjectionMatrix * vec4(vert, 1.0);
}
