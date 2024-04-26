precision highp float;

uniform sampler2D texDist; 
uniform sampler2D texDistMax; 
uniform sampler2D texRandom;
uniform vec2 uniTexelDist;
uniform vec2 uniTexelRandom;
uniform vec2 uniSizeDist;
uniform vec2 uniSeed;
uniform float uniProbability;


vec4 Random(vec2 _offset)
{
	return texture2D(texRandom, _offset * 12.9898 + uniSeed);
}


void main()
{
	// Start with random. 
	// Maximum distance is stored in 1x1 texture.
	vec2 _coord = vec2(0.5);
	vec4 _random = Random(gl_FragCoord.xy);
	float _distMax = texture2D(texDistMax, _coord).r;
	float _threshold = _random[3] * _distMax * uniProbability;
	
	// Randomly sample until goes over threshold.
	float _debugFound = -1.0;
	vec2 _position = vec2(0.0);
	for(float i = 0.0; i < 256.0; i++)
	{
		_random = Random(_random.xy + vec2(i) / 256.0);
		_position = floor(uniSizeDist * _random.xy);
		_position = clamp(_position, vec2(0.0), uniSizeDist - 1.0);
		_coord = (_position + 0.5) / uniSizeDist;
		_threshold -= texture2D(texDist, _coord).r;
		if (_threshold <= 0.0)
		{
			_debugFound = 1.0;
			break;
		}
	}
	
	// Store position, may have found or iterations were not enough.
	gl_FragData[0] = vec4(_position, _debugFound, 1.0);
}
