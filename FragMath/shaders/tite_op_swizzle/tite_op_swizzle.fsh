precision highp float;
uniform sampler2D texA;
uniform vec2 uniTexelA;
uniform int uniR;
uniform int uniG;
uniform int uniB;
uniform int uniA;

void main()
{
	// Get the input value.
	vec4 lhs = texture2D(texA, gl_FragCoord.xy * uniTexelA);
	
	// Do the calculation.
	vec4 res;
	#ifdef _YY_HLSL11_
		res = vec4(lhs[uniR], lhs[uniG], lhs[uniB], lhs[uniA]);
	#else
		// To work in WebGL, as array indexes must be constants.
		res[0] = (uniR == 0) ? lhs[0] : ((uniR == 1) ? lhs[1] : ((uniR == 2) ? lhs[2] : lhs[3]));
		res[1] = (uniG == 0) ? lhs[0] : ((uniG == 1) ? lhs[1] : ((uniG == 2) ? lhs[2] : lhs[3]));
		res[2] = (uniB == 0) ? lhs[0] : ((uniB == 1) ? lhs[1] : ((uniB == 2) ? lhs[2] : lhs[3]));
		res[3] = (uniA == 0) ? lhs[0] : ((uniA == 1) ? lhs[1] : ((uniA == 2) ? lhs[2] : lhs[3]));
	#endif

	// Store the result.
	gl_FragData[0] = res;
}
