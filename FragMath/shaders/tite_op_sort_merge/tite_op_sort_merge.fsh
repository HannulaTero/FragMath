//-------------------------------------------------------------------
//
#region INFORMATION
/*

This is sorting pass variant, which finds correct value for given position
	The workload is inbalanced! Search space is smaller near edges.
	Input texture must have sides powers of two. 

Uses Mergesort to sort values in several passes
	Normally mergesort is applied for 1D, but as textures are 2D, 
	Values are sorted in texture with horizontal order, first [0,0], last [1,1].
	This shader tries act acts like texture is 1D array by calculating equilevant 1D index
	The problem is that maximum integer a floating point number can have
		With F32 that would be about 16 million, which should be enough for 4096x4096 texture
		But float precision might vary between gpus, and therefore this might actually be smaller. 

Normally in parallel mergesort one would take a value and find where it should be placed
	This doesn't work nicely with fragment shader, as the render position can't be changed.
	Instead we will take position, and find which value should be taken.
	This will cause workload inbalance, but works with fragment shader.

Sorter texture information:
	R: x-coordinate
	G: y-coordinate
	B: sort value
	A: [unused]
		

*/
#endregion
//
//-------------------------------------------------------------------
//
#region UNIFORMS & OTHER


precision highp float;

uniform sampler2D texA;
uniform vec2 uniTexelA;
uniform vec2 uniSizeA;
uniform float uniSearch;
uniform float uniRange;


#endregion
//
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


void main() {
	// Output position
	vec2 pos = floor(gl_FragCoord.xy);
	float index = Permute(pos);
	
	// Make 2D search space into 1D.
	float lhsStart = floor(index / uniSearch) * uniSearch;
	float rhsStart = lhsStart + uniRange;
	float steps = index - lhsStart + 1.0;
	float lhsPtr = 0.0;
	float rhsPtr = 0.0;
	vec4 lhs, rhs;

	// Binary search
	float repeats = ceil(log2(steps));
	for(float i = 0.0; i < 24.0; i++) {
		if (i >= repeats) break;
		
		float mid = floor(steps * 0.5);
		float lhsOff = min(lhsPtr + mid, uniRange);
		float rhsOff = min(rhsPtr + mid, uniRange);
		lhs = Sample(lhsStart + lhsOff - 1.0);
		rhs = Sample(rhsStart + rhsOff - 1.0);
		
		if (lhs.z <= rhs.z) 
		{
			steps -= (lhsOff - lhsPtr);
			lhsPtr = lhsOff;
		} 
		else 
		{
			steps -= (rhsOff - rhsPtr);
			rhsPtr = rhsOff;
		}
	}
	
	// Choose the value
	if (lhsPtr >= uniRange) 
	{
		rhsPtr += steps - 1.0;
		gl_FragData[0] = Sample(rhsStart + rhsPtr);
		return;
	}
	
	if (rhsPtr >= uniRange) 
	{
		lhsPtr += steps - 1.0;
		gl_FragData[0] = Sample(lhsStart + lhsPtr);
		return;
	}
	
	lhs = Sample(lhsStart + lhsPtr);
	rhs = Sample(rhsStart + rhsPtr);
	gl_FragData[0] = (lhs.z <= rhs.z) ? lhs : rhs;	
}


#endregion
//
//-------------------------------------------------------------------




