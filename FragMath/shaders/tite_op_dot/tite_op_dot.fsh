precision highp float;
uniform sampler2D texA;
uniform sampler2D texB;
uniform vec2 uniTexelA;
uniform vec2 uniTexelB;
uniform vec2 uniStartA;
uniform vec2 uniStartB;
uniform vec2 uniStepsA;
uniform vec2 uniStepsB;
uniform float uniIterations;

// This shader iterates through given target dimension.
void main()
{
	// Choose starting coordinates.
	vec2 _pos = floor(gl_FragCoord.xy);
	vec2 _coordA = (_pos * uniStartA + 0.5) * uniTexelA;
	vec2 _coordB = (_pos * uniStartB + 0.5) * uniTexelB;
	
	// Sum-reduce given dimension.
	vec4 _out = vec4(0.0);
	for(float i = 0.0; i < 16384.0; i++) 
	{
		if (i >= uniIterations) break;
		vec4 _lhs = texture2D(texA, _coordA);
		vec4 _rhs = texture2D(texB, _coordB);
		_coordA += uniStepsA;
		_coordB += uniStepsB;
		_out += _lhs * _rhs;
	}

	// Store the result.
	gl_FragData[0] = _out;
}
