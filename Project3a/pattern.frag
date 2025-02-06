// lighting uniform variables -- these can be set once and left alone:
uniform float   uKa, uKd, uKs;	 // coefficients of each type of lighting -- make sum to 1.0
uniform float   uShininess;	 // specular exponent

uniform float   uA, uP;  //project3

// in variables from the vertex shader and interpolated in the rasterizer:
varying  vec3  vN;		   // normal vector
varying  vec3  vL;		   // vector from point to light
varying  vec3  vE;		   // vector from point to eye
varying  vec2  vST;		   // (s,t) texture coordinates
varying  vec3  vMC;		   // model coordinates

const vec3 OBJECTCOLOR          = vec3( 1., 1.3, 1.2 );           // color to make the object
const vec3 SPECULARCOLOR        = vec3( 1., 1.2, 1. );

void main() {
  	vec3 myColor = OBJECTCOLOR;
	vec2 st = vST;

	// now use myColor in the per-fragment lighting equations:

	vec3 Normal    = normalize(gl_NormalMatrix * vN);
	vec3 Light     = normalize(vL);
	vec3 Eye       = normalize(vE);

  	vec3 ambient = uKa * myColor;

	float d = max( dot(Normal,Light), 0. );       // only do diffuse if the light can see the point
	vec3 diffuse = uKd * d * myColor;

	float s = 0.;
	if( d > 0. )              // only do specular if the light can see the point
	{
		vec3 ref = normalize(  reflect( -Light, Normal )  );
		float cosphi = dot( Eye, ref );
		if( cosphi > 0. )
				s = pow( max( cosphi, 0. ), uShininess );
	}

	vec3 specular = uKs * s * SPECULARCOLOR.rgb;
	gl_FragColor = vec4( ambient + diffuse + specular,  1. );
}
