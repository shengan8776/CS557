uniform float uSc, uTc, uRad;
uniform float uMag, uWhirl, uMosaic; 

uniform sampler2D uImageUnit;

varying vec2 vST;

void main() {
    vec2 st = vST  - vec2(uSc, uTc);
    float r = length(st);

    if (r >= uRad) {
        vec3 rgb = texture2D(uImageUnit, vST).rgb;
        gl_FragColor = vec4(rgb, 1.);
    }	
	else {
		float rprime = r / uMag;

		float theta = atan(st.t, st.s);
    	float thetaprime = theta - uWhirl * rprime;

		st = rprime * vec2(cos(thetaprime), sin(thetaprime));
		st += vec2(uSc, uTc);

		float MosaicR = uMosaic / 2.; 
		int numins = int(st.s / MosaicR);
		int numint = int(st.t / MosaicR);
		float sc = (float(numins) * uMosaic) + MosaicR;
		float tc = (float(numint) * uMosaic) + MosaicR;
		st.s = sc;
		st.t = tc;
		
		vec3 rgb = texture2D(uImageUnit, st).rgb;
    	gl_FragColor = vec4(rgb, 1.);
	}
    
}