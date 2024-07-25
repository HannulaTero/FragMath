precision highp float;
uniform vec2 uniSize;

void main()
{
	vec2 coord = floor(gl_FragCoord.xy);
	float index = coord.x + uniSize.x * coord.y;
	gl_FragData[0] = vec4(index, 0.0, 0.0, 1.0);
}
