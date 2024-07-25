precision highp float;

const float MAX_RANGE = 16384.0;

uniform sampler2D texA;
uniform vec2 uniTexelA;
uniform vec2 uniRange;

// Mean-reduces MxN area.
void main() {	
	vec4 value = vec4(0.0);
	vec2 position = floor(gl_FragCoord.xy) * uniRange + 0.5;
	vec2 coord;
	for(float j = 0.0; j < MAX_RANGE; j++) 
	{
		if (j >= uniRange.x) break;
		for(float i = 0.0; i < MAX_RANGE; i++) 
		{
			if (i >= uniRange.x) break;
			coord = (position + vec2(i, j)) * uniTexelA;
			value += texture2D(texA, coord);
		}
	}
	
	gl_FragData[0] = value / (uniRange.x * uniRange.y);
}

