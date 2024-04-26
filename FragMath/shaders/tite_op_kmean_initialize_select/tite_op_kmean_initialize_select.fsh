precision highp float;

uniform sampler2D texPos; // Sample position.
uniform sampler2D texDim; // Data dimension.
uniform vec2 uniTexelPos;

void main()
{
	vec2 _tmp = vec2(0.5, gl_FragCoord.y);
	vec4 _lhs = texture2D(texPos, _tmp * uniTexelPos);
	vec4 _out = texture2D(texDim, _lhs.xy);
	gl_FragData[0] = _out;
}
