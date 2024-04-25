precision highp float;
uniform sampler2D texA;
uniform vec2 uniTexelA;
uniform vec2 uniSizeA;
uniform float uniOffset;


//-------------------------------------------------------------------
//
#region FUNCTIONS


float Permute(vec2 pos) 
{
	return pos.x + pos.y * uniSizeA.x;
}


vec2 Permute(float index) 
{
	vec2 pos;
	pos.y = floor(index / uniSizeA.x);
	pos.x = index - pos.y * uniSizeA.x;
	return pos;
}


vec4 Sample(vec2 pos) 
{
	vec2 coord = (pos + 0.5) * uniTexelA;
	return texture2D(texA, coord);
}


vec4 Sample(float index) 
{
	return Sample(Permute(index));
}


#endregion
//
//-------------------------------------------------------------------
//
#region MAIN FUNCTION


void main() 
{
	vec4 result = vec4(-1.0);
	vec2 pos = floor(gl_FragCoord.xy);
	float index = Permute(pos);
	
	// Case Even
	if (mod(index + uniOffset, 2.0) < 0.5) {
		vec4 lhs = Sample(index);
		vec4 rhs = Sample(index + 1.0);
		result = (lhs.z <= rhs.z) ? lhs : rhs;
		
	// Case Odd
	} else {
		vec4 lhs = Sample(index - 1.0);
		vec4 rhs = Sample(index);
		result = (lhs.z <= rhs.z) ? rhs : lhs;
	}
	
	// Result
	gl_FragData[0] = result;	
}


#endregion
//
//-------------------------------------------------------------------
