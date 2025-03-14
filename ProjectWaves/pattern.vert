// out variables to be interpolated in the rasterizer and sent to each fragment shader:

varying  vec3  vN;	  // normal vector
varying  vec3  vL;	  // vector from point to light
varying  vec3  vE;	  // vector from point to eye
varying  vec2  vST;	  // (s,t) texture coordinates
varying  vec3  vMC;   // model coordinates

// uniforms   //project3
uniform float  uA, uP;
uniform float  uLightX, uLightY, uLightZ;

// where the light is:
vec3 LightPosition = vec3( uLightX, uLightY, uLightZ );  //project3

const float Y0 = 1.;
const float F_PI = 3.14;

void
main( )
{
	// apply sin function to create pleates  //project3
    vec4 vert = gl_Vertex;
    vert.z = uA * (Y0 - vert.y) * sin(2. * F_PI * (vert.x / uP));

    // calculate values to get new normals
    float dzdx = uA * (Y0 - vert.y) * ((2. * F_PI) / uP) * cos(2. * F_PI * (vert.x / uP));
    float dzdy = -uA * sin(2. * F_PI * (vert.x / uP));
    vec3 Tx = vec3(1., 0., dzdx);
    vec3 Ty = vec3(0., 1., dzdy);


	vST = gl_MultiTexCoord0.st;
	vMC = vert.xyz;
	vec4 ECposition = gl_ModelViewMatrix * vert; // eye coordinate position
	vN = normalize( cross(Tx, Ty) );  // normal vector  
	vL = LightPosition - ECposition.xyz;	    // vector from the point to the light position
	vE = vec3( 0., 0., 0. ) - ECposition.xyz;       // vector from the point to the eye position
	gl_Position = gl_ModelViewProjectionMatrix * vert;
}
