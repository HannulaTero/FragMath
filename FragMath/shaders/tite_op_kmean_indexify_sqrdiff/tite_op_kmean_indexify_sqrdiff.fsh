precision highp float;

uniform sampler2D texDim; 
uniform vec2 uniTexelDim;

uniform sampler2D texClusters;
uniform vec2 uniTexelClusters;
uniform vec2 uniClusterIndex;

void main()
{
	vec4 _lhs = texture2D(texDim, gl_FragCoord.xy * uniTexelDim);
	vec4 _rhs = texture2D(texClusters, (uniClusterIndex + 0.5) * uniTexelClusters);
	vec4 _sqr = pow(_lhs - _rhs, vec4(2.0));
	float _dist = (_sqr.x + _sqr.y + _sqr.z + _sqr.w);
	gl_FragData[0].r = _dist;
}
