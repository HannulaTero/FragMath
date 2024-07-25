precision highp float;

uniform sampler2D texA; // Randomized: [coord.xy, index, unused]
uniform sampler2D texB; // Possible values.
uniform vec2 uniTexelA;
uniform vec2 uniTexelB;
uniform float uniIndex;

void main()
{
	vec4 lhs = texture2D(texA, gl_FragCoord.xy * uniTexelA);
	vec4 rhs = (floor(lhs.z) == uniIndex)
		? texture2D(texB, lhs.xy)
		: vec4(0.0);
	gl_FragData[0] = rhs;
}
