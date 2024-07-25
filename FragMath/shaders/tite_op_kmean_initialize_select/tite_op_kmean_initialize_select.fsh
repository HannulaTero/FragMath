precision highp float;

uniform sampler2D texPos; // Sample position.
uniform sampler2D texDim; // Data dimension.
uniform vec2 uniTexelPos;

void main()
{
	vec2 tmp = vec2(0.5, gl_FragCoord.y);
	vec4 lhs = texture2D(texPos, tmp * uniTexelPos);
	vec4 res = texture2D(texDim, lhs.xy);
	gl_FragData[0] = res;
}
