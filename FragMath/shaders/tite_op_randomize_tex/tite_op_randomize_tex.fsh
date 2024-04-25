precision highp float;
uniform vec2 uniTexelA;
uniform vec4 uniMin;
uniform vec4 uniMax;
uniform vec4 uniSeedX;
uniform vec4 uniSeedY;
uniform vec4 uniFactor;

float random(vec2 _seed) 
{
    return fract(sin(dot(_seed, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main()
{
	// Do the calculation.
	vec2 _coord = gl_FragCoord.xy * uniTexelA;
	vec4 _out;
	for(int i = 0; i < 4; i++)
	{
		vec2 _seed = vec2(uniSeedX[i], uniSeedY[i]);
		float _rate = random(_coord * uniFactor[i] + _seed);
		_out[i] = mix(uniMin[i], uniMax[i], _rate);
	}

	// Store the result.
	gl_FragData[0] = _out;
}
