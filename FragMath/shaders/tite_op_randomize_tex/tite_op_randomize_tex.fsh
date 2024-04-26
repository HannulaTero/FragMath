precision highp float;
uniform sampler2D texRandom;
uniform vec2 uniTexelRandom;
uniform vec2 uniSeed;
uniform vec4 uniMin;
uniform vec4 uniMax;

void main()
{
	vec2 _coord = gl_FragCoord.xy * uniTexelRandom;
	vec2 _modified = _coord * 12.9898 + uniSeed;
	vec4 _rate = texture2D(texRandom, _modified);
	gl_FragData[0] = mix(uniMin, uniMax, _rate);
}
