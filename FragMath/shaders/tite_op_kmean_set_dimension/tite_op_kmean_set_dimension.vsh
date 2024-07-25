// Attributes, match format.
attribute vec2 in_Pos;
attribute vec2 in_Off;

// Varyings.
varying vec4 vDataValue;

// Uniforms.
uniform sampler2D texSrc;
uniform vec2 uniSrcTexel;
uniform vec2 uniSrcSize;

uniform vec2 uniDstTexel;
uniform vec2 uniDstSize;

uniform float uniCountDatapoints;
uniform float uniCountDimensions;
uniform float uniCountClusters;

uniform float uniOffset;
uniform float uniDimension;

uniform vec2 uniBatchBias;
uniform vec2 uniBatchOffset;

// Main function.
void main()
{
	// Get current source position and data-index.
	vec2 srcPosition = in_Pos + uniBatchOffset;
	float indexData = srcPosition.x + srcPosition.y * uniSrcSize.x;
	float indexValue = (indexData + uniOffset) * uniCountDimensions + uniDimension;
	
	// If position is outside the range.
	if (indexValue >= uniCount * uniCountDimensions)
	{
		gl_Position = vec4(-2.0, -2.0, 0.0, 1.0);
		return;
	}
	
	// Read the datavalue from source.
	vec2 srcCoord = (srcPosition + 0.5) * uniSrcTexel;
	vDataValue = texture2DLod(texSrc, srcCoord, 0.0);
	
	// Get destination position.
	vec2 dstPosition;
	dstPosition.y = floor(indexDatapoint / uniDstSize.x);
	dstPosition.x = indexDatapoint - dstPosition.y * uniDstSize.x;
	
	// Move vertices around to correct position for destination.
	position += 0.5 * uniSize * (in_Off * 2.0 - 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(position, 0.0, 1.0);
}
