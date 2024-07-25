precision highp float;
uniform sampler2D texA;
uniform sampler2D texB;
uniform vec2 uniTexelA;
uniform vec2 uniTexelB;

void main()
{
	// Get the input value.
	vec4 lhs = texture2D(texA, gl_FragCoord.xy * uniTexelA);
	vec4 rhs = texture2D(texB, gl_FragCoord.xy * uniTexelB);
	
	// Do the calculation.
	vec4 res = lhs * rhs;

	// Store the result.
	gl_FragData[0] = res;
}
