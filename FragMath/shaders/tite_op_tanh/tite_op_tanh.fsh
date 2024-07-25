precision highp float;
uniform sampler2D texA;
uniform vec2 uniTexelA;

void main()
{
	// Get the input value.
	vec4 lhs = texture2D(texA, gl_FragCoord.xy * uniTexelA);
	
	// Do the calculation.
	vec4 a = exp(+lhs);
	vec4 b = exp(-lhs);
	vec4 res = (a - b) / (a + b);

	// Store the result.
	gl_FragData[0] = res;
}
