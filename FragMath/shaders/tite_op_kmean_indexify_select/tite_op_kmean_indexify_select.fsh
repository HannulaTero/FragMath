precision highp float;

uniform sampler2D texDistPrev;
uniform sampler2D texDistCurr;
uniform sampler2D texIndexPrev;
uniform vec2 uniTexel; // All samplers should have same dimension.
uniform float uniIndexCurr;

void main()
{
	vec2 _coord = gl_FragCoord.xy * uniTexel;
	float _distPrev = texture2D(texDistPrev, _coord).r;
	float _distCurr = texture2D(texDistCurr, _coord).r;
	if (_distPrev <= _distCurr)
	{
		gl_FragData[0].r = texture2D(texIndexPrev, _coord).r;
		gl_FragData[1].r = texture2D(texDistPrev, _coord).r;
	}
	else
	{
		gl_FragData[0].r = uniIndexCurr;
		gl_FragData[1].r = texture2D(texDistCurr, _coord).r;
	}
}
