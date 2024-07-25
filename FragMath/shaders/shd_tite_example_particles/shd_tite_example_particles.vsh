// Attributes, match format.
attribute vec2 in_Pos;
attribute vec2 in_Off;

// Varyings.
varying vec2 vCoord;

// Uniforms.
uniform sampler2D texA;
uniform vec2 uniTexelA;
uniform vec2 uniSize;
uniform float uniUVs[8];
uniform vec2 uniBatchOffset;

// Main function.
void main()
{
	// Move vertices around based on position texture.
	vec2 coord = (in_Pos + uniBatchOffset + 0.5) * uniTexelA;
	vec2 position = texture2DLod(texA, coord, 0.0).xy;
	position += 0.5 * uniSize * (in_Off * 2.0 - 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(position, 0.0, 1.0);
	
	// Texture coordinate.
	vCoord = vec2(
		mix(uniUVs[0], uniUVs[2], in_Off.x),
		mix(uniUVs[1], uniUVs[3], in_Off.y)
	);
}
