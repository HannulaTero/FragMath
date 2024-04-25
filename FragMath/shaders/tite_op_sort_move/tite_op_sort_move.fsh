precision highp float;
uniform sampler2D texA;
uniform sampler2D texB;
uniform vec2 uniTexelA;
uniform vec2 uniTexelB;

// Moves values around based on sorting structure.
void main()
{
	vec2 coordA = gl_FragCoord.xy * uniTexelA;
	vec4 sorter = texture2D(texA, coordA);
	vec2 coordB = (sorter.xy + 0.5) * uniTexelB;
	gl_FragData[0] = (sorter.a > 0.5)
		? texture2D(texB, coordB)
		: vec4(0.0);
}
