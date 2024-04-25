precision highp float;

uniform sampler2D texA;
uniform vec2 uniTexelA;

// Assumes float texture.
void main()
{
	vec4 _sample = texture2D(texA, gl_FragCoord.xy * uniTexelA);
	
	// Gamma correction.
	vec3 _color = pow(_sample.rgb, vec3(2.2));
	
	// Convert to xyz.
	vec3 _transform = vec3(
		dot(vec3(_color[0]), vec3(0.4124564, 0.3575761, 0.1804375)),
		dot(vec3(_color[1]), vec3(0.2126729, 0.7151522, 0.0721750)),
		dot(vec3(_color[2]), vec3(0.0193339, 0.1191920, 0.9503041))
	);
	
	// Get rate.
	vec3 _rate;
	for(int i = 0; i < 3; i++)
	{
		_rate[i] = (_transform[i] > 0.008856) 
			? pow(_transform[i], 1.0/3.0) 
			: ((903.3 * _transform[i] + 16.0) / 116.0);
	}
	
	// Convert to LAB color.
	vec3 _lab = vec3(
		(116.0 * _rate[1]) - 16.0,
		500.0 * (_rate[0] - _rate[1]),
		200.0 * (_rate[1] - _rate[2])
	);

	gl_FragData[0] = vec4(_lab, _sample.a);
}
