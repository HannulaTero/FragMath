precision highp float;

uniform sampler2D texDist; 
uniform sampler2D texDistMax; 
uniform sampler2D texRandom;
uniform vec2 uniTexelDist;
uniform vec2 uniTexelRandom;
uniform vec2 uniSizeDist;
uniform vec2 uniSeed;
uniform float uniProbability;


vec4 Random(vec2 offset)
{
	return texture2D(texRandom, offset * 12.9898 + uniSeed);
}


void main()
{
	// Start with random. 
	// Maximum distance is stored in 1x1 texture.
	vec2 coord = vec2(0.5);
	vec4 random = Random(gl_FragCoord.xy);
	float distMax = texture2D(texDistMax, coord).r;
	float threshold = random[3] * distMax * uniProbability;
	
	// Randomly sample until goes over threshold.
	float debugFound = -1.0;
	vec2 position = vec2(0.0);
	for(float i = 0.0; i < 256.0; i++)
	{
		random = Random(random.xy + vec2(i) / 256.0);
		position = floor(uniSizeDist * random.xy);
		position = clamp(position, vec2(0.0), uniSizeDist - 1.0);
		coord = (position + 0.5) / uniSizeDist;
		threshold -= texture2D(texDist, coord).r;
		if (threshold <= 0.0)
		{
			debugFound = 1.0;
			break;
		}
	}
	
	// Store position, may have found or iterations were not enough.
	gl_FragData[0] = vec4(position, debugFound, 1.0);
}
