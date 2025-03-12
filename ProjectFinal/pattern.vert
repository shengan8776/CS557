varying vec2 vST;   // (s,t) texture coordinates
varying vec3 vN;    // normal vector
varying vec3 vL;    // vector from point to light
varying vec3 vE;    // vector from point to eye
varying vec3 vMC;   // model coordinates



uniform float uTimeScale;
//uniform float uG;
//uniform float uH;
uniform float uAm0;
uniform float uKm0;
uniform float uGamma0;
uniform float uAm1;
uniform float uKm1;
uniform float uPhiM1;
uniform float uGamma1;

uniform float Timer;

uniform float uLightX, uLightY, uLightZ;
vec3 eyeLightPosition = vec3( uLightX, uLightY, uLightZ );


const vec3 LIGHTPOSITION = vec3(5., 5., 0.); //vec3(  8., 1., 3. );
const float PI = 3.14159265;
const float G = 1.;

void main()
{
	float newx = gl_Vertex.x;
	float newy = 0.;
	float newz = gl_Vertex.z;
	float dxda = 1.;
	float dyda = 0.;
	float dzda = 0.;
	float dxdb = 0.;
	float dydb = 0.;
	float dzdb = 1.;

	float wm1 = sqrt( G*uKm1 );
	float thetam = gl_Vertex.x*uKm1*cos(uGamma1)+ gl_Vertex.z*uKm1*sin(uGamma1) - wm1*Timer*uTimeScale - uPhiM1;
	newx -= uAm1*cos(uGamma1)*sin(thetam);
	newy += uAm1 * cos(thetam);
	newz -= uAm1*sin(uGamma1)*sin(thetam);
	float dthetamda = uKm1*cos(uGamma1);
	float dthetamdb = uKm1*sin(uGamma1);
	dxda -= uAm1*cos(uGamma1)*cos(thetam)*dthetamda;
	dyda -= uAm1*sin(thetam)*dthetamda;
	dzda -= uAm1*sin(uGamma1)*cos(thetam)*dthetamda;
	dxdb -= uAm1*cos(uGamma1)*cos(thetam)*dthetamdb;
	dydb -= uAm1*sin(thetam)*dthetamdb;
	dzdb -= uAm1*sin(uGamma1)*cos(thetam)*dthetamdb;

	vec3 newVertex = vec3( newx, newy, newz );
	vMC = newVertex;
	vec3 ta = vec3( dxda, dyda, dzda );
	vec3 tb = vec3( dxdb, dydb, dzdb );

	//vNs
	vN = normalize( gl_NormalMatrix*cross( tb, ta ) );
	// surface normal vector
	vec4 ECposition = gl_ModelViewMatrix * vec4( newVertex, 1. );

	//vLS
	vL = normalize( eyeLightPosition - ECposition.xyz ); // vector from the point to the light position
	//vEs
	vE = normalize( vec3( 0., 0., 0. ) - ECposition.xyz ); // vector from the point to the eye position
	gl_Position = gl_ModelViewProjectionMatrix * vec4( newVertex, 1.);

    //per-fragment lighting
    vST = gl_MultiTexCoord0.st;
    //vMC = gl_Vertex.xyz;
    //vec4 ECposition = gl_ModelViewMatrix * gl_Vertex; // eye coordinate position
    //vN = normalize(gl_NormalMatrix * gl_Normal);            // normal vector
    //vL = LIGHTPOSITION - ECposition.xyz;                    // vector from the point to the light position
    //vE = vec3(0., 0., 0.) - ECposition.xyz;                 // vector from the point to the eye position
    //vZ = -ECposition.z;

    //gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
