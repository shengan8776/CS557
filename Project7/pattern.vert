varying vec2 vST;   // (s,t) texture coordinates
varying vec3 vN;    // normal vector
varying vec3 vL;    // vector from point to light
varying vec3 vE;    // vector from point to eye
varying vec3 vMC;   // model coordinates

uniform float uTwist;

const vec3 LIGHTPOSITION = vec3(5., 5., 0.); //vec3(  8., 1., 3. );
const float PI = 3.14159265;
const float TWOPI = 2.0 * PI;

vec3 RotateX(vec3 xyz, float radians)
{
	float c = cos(radians);
	float s = sin(radians);
	vec3 newxyz = xyz;
	newxyz.yz = vec2(
		dot( xyz.yz, vec2( c,-s) ),
		dot( xyz.yz, vec2( s, c) )
	);
	return newxyz;
}

vec3 RotateY(vec3 xyz, float radians)
{
	float c = cos(radians);
	float s = sin(radians);
	vec3 newxyz = xyz;
	newxyz.xz =vec2(
		dot( xyz.xz, vec2( c,s) ),
		dot( xyz.xz, vec2(-s,c) )
	);
	return newxyz;
}

vec3 RotateZ(vec3 xyz, float radians)
{
	float c = cos(radians);
	float s = sin(radians);
	vec3 newxyz = xyz;
	newxyz.xy = vec2(
		dot( xyz.xy, vec2( c,-s) ),
		dot( xyz.xy, vec2( s, c) )
	);
	return newxyz;
}

void main()
{   
    float distanceFromZAxis = length(gl_Vertex.xy);
    float distanceFromYAxis = length(gl_Vertex.xz);

    float direction = sign(gl_Vertex.z) * distanceFromYAxis;    //simulate two-hand twisting
    float radians = TWOPI * uTwist * distanceFromZAxis * direction;

    vec3 vert = RotateZ(gl_Vertex.xyz, radians);

    //per-fragment lighting
    vST = gl_MultiTexCoord0.st;
    vMC = gl_Vertex.xyz;
    vec4 ECposition = gl_ModelViewMatrix * vec4(vert, 1.0); // eye coordinate position
    vN = normalize(gl_NormalMatrix * gl_Normal);            // normal vector
    vL = LIGHTPOSITION - ECposition.xyz;                    // vector from the point to the light position
    vE = vec3(0., 0., 0.) - ECposition.xyz;                 // vector from the point to the eye position

    gl_Position = gl_ModelViewProjectionMatrix * vec4(vert, 1.0);
}
