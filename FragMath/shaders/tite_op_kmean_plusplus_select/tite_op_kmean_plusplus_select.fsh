precision highp float;

uniform sampler2D texPos; // Sample position (1x1).
uniform sampler2D texDim; // Data dimension.
uniform vec2 uniTexelDim;

void main()
{
	vec4 _lhs = texture2D(texPos, vec2(0.5, 0.5));
	vec4 _out = texture2D(texDim, _lhs.xy * uniTexelDim);
	gl_FragData[0] = _out;
}
