precision highp float;
uniform sampler2D texRandom;
uniform vec2 uniTexelRandom;
uniform vec2 uniSeed;
uniform vec4 uniMin;
uniform vec4 uniMax;

void main()
{
	vec2 coord = gl_FragCoord.xy * uniTexelRandom;
	vec2 modified = coord * 12.9898 + uniSeed;
	vec4 rate = texture2D(texRandom, modified);
	gl_FragData[0] = mix(uniMin, uniMax, rate);
}
