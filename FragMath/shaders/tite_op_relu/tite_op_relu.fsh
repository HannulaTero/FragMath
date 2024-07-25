precision highp float;
uniform sampler2D texA;
uniform vec2 uniTexelA;

void main()
{
	// Get the input value.
	vec4 lhs = texture2D(texA, gl_FragCoord.xy * uniTexelA);
	
	// Do the calculation.
	vec4 res = max(vec4(0.0), lhs);

	// Store the result.
	gl_FragData[0] = res;
}
