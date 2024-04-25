precision highp float;
uniform sampler2D texA;
uniform vec2 uniTexelA;
uniform vec2 uniSizeA;
uniform float uniCount;
uniform float uniNonSort;

// Creates sortable structure. 
// Coordinate to original position, and sorting value.
void main()
{
	vec2 pos = floor(gl_FragCoord.xy);
	vec2 coord = gl_FragCoord.xy * uniTexelA;
	float index = pos.x + pos.y * uniSizeA.x;
	gl_FragData[0] = (index < uniCount)
		? vec4(pos, texture2D(texA, coord).r, 1.0)
		: vec4(-1.0, -1.0, uniNonSort, 0.0);
}
