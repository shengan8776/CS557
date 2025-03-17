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

//const vec3 LIGHTPOSITION = vec3(5., 5., 0.); //vec3(  8., 1., 3. );
const float PI = 3.14159265;
const float G = 1.;


// Create a rotation matrix to align with the wave normal
mat3 createRotationMatrix(vec3 normal) {
    // Ensure normal is normalized
    normal = normalize(normal);
    
    // First basis vector: Use the normal as the new up direction
    vec3 newUp = normal;
    
    // Second basis vector: Choose a direction perpendicular to newUp
    vec3 candidate = abs(normal.x) < abs(normal.z) ? 
                     vec3(1.0, 0.0, 0.0) : vec3(0.0, 0.0, 1.0);
    
    // Make it perpendicular to newUp
    vec3 newRight = normalize(cross(candidate, newUp));
    
    // Third basis vector: Complete the orthonormal basis
    vec3 newForward = normalize(cross(newUp, newRight));
    
    // Construct the rotation matrix using the new basis vectors as columns
    return mat3(
        newRight.x, newUp.x, newForward.x,
        newRight.y, newUp.y, newForward.y,
        newRight.z, newUp.z, newForward.z
    );
}

void main()
{
    //fixed anchor position for the duck
    float anchorX = 0.0;
    float anchorZ = 0.0;

    //float newx = gl_Vertex.x;
	float newy = 0.;
	//float newz = gl_Vertex.z;
	float dxda = 1.;
	float dyda = 0.;
	float dzda = 0.;
	float dxdb = 0.;
	float dydb = 0.;
	float dzdb = 1.;

	//m = 0
	{
		float phiM0 = 0.; // m=0 is the phase baseline
		float wm0 = sqrt( G*uKm0 );
		float thetam = anchorX*uKm0*cos(uGamma0)+ anchorZ*uKm0*sin(uGamma0) - wm0*Timer*uTimeScale - phiM0;
		//newx -= uAm0*cos(uGamma0)*sin(thetam);
		newy += uAm0 * cos(thetam);
		//newz -= uAm0*sin(uGamma0)*sin(thetam);
		float dthetamda = uKm0*cos(uGamma0);
		float dthetamdb = uKm0*sin(uGamma0);
		dxda -= uAm0*cos(uGamma0)*cos(thetam)*dthetamda;
		dyda -= uAm0*sin(thetam)*dthetamda;
		dzda -= uAm0*sin(uGamma0)*cos(thetam)*dthetamda;
		dxdb -= uAm0*cos(uGamma0)*cos(thetam)*dthetamdb;
		dydb -= uAm0*sin(thetam)*dthetamdb;
		dzdb -= uAm0*sin(uGamma0)*cos(thetam)*dthetamdb;
	}
	
	//m = 1
	{
		float wm1 = sqrt( G*uKm1 );
		float thetam = anchorX*uKm1*cos(uGamma1)+ anchorZ*uKm1*sin(uGamma1) - wm1*Timer*uTimeScale - uPhiM1;
		//newx -= uAm1*cos(uGamma1)*sin(thetam);
		newy += uAm1 * cos(thetam);
		//newz -= uAm1*sin(uGamma1)*sin(thetam);
		float dthetamda = uKm1*cos(uGamma1);
		float dthetamdb = uKm1*sin(uGamma1);
		dxda -= uAm1*cos(uGamma1)*cos(thetam)*dthetamda;
		dyda -= uAm1*sin(thetam)*dthetamda;
		dzda -= uAm1*sin(uGamma1)*cos(thetam)*dthetamda;
		dxdb -= uAm1*cos(uGamma1)*cos(thetam)*dthetamdb;
		dydb -= uAm1*sin(thetam)*dthetamdb;
		dzdb -= uAm1*sin(uGamma1)*cos(thetam)*dthetamdb;
	}

	//vec3 newVertex = vec3( newx, newy, newz );
	vec3 ta = vec3( dxda, dyda, dzda );
	vec3 tb = vec3( dxdb, dydb, dzdb );
    float waveHeight = newy;
    
    
    // Calculate the wave normal by taking the cross product of the tangents
    vec3 waveNormal = normalize(cross(tb, ta));
    
    // Create a rotation matrix that aligns with the wave normal
    mat3 rotationMatrix = createRotationMatrix(waveNormal);
    
    // Apply the rotation to the vertex to make the duck tilt
    vec3 rotatedVertex = rotationMatrix * gl_Vertex.xyz;
    
    // Position the vertex at the anchor point and at the correct height
    vec3 newPos = rotatedVertex;
    newPos.x += anchorX;
    newPos.y += waveHeight + 0.15; //small offset to float above water
    newPos.z += anchorZ;
    

    //per-fragment lighting
    vST = gl_MultiTexCoord0.st;
    vMC = gl_Vertex.xyz;
    vec4 ECposition = gl_ModelViewMatrix * vec4(newPos, 1.0);
    
    //rotate the vertex normal
    vec3 rotatedNormal = rotationMatrix * gl_Normal;
    vN = normalize(gl_NormalMatrix * rotatedNormal);
    
    vL = eyeLightPosition - ECposition.xyz;
    vE = vec3(0.0, 0.0, 0.0) - ECposition.xyz;
    
    gl_Position = gl_ModelViewProjectionMatrix * vec4(newPos, 1.0);
}
