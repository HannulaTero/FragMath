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
	vec2 pos = floor(gl_FragCoord.xy);
	vec2 coordA = (pos * uniStartA + 0.5) * uniTexelA;
	vec2 coordB = (pos * uniStartB + 0.5) * uniTexelB;
	
	// Sum-reduce given dimension.
	vec4 res = vec4(0.0);
	for(float i = 0.0; i < 16384.0; i++) 
	{
		if (i >= uniIterations) break;
		vec4 lhs = texture2D(texA, coordA);
		vec4 rhs = texture2D(texB, coordB);
		coordA += uniStepsA;
		coordB += uniStepsB;
		res += lhs * rhs;
	}

	// Store the result.
	gl_FragData[0] = res;
}
