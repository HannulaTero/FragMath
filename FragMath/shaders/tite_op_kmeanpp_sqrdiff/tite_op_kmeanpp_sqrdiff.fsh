precision highp float;

uniform sampler2D texDim; 
uniform vec2 uniTexelDim;

uniform sampler2D texClusters;
uniform vec2 uniTexelClusters;
uniform vec2 uniClusterIndex;

void main()
{
	vec4 _lhs = texture2D(texDim, gl_FragCoord.xy * uniTexelDim);
	vec4 _rhs = texture2D(texClusters, uniClusterIndex * uniTexelClusters);
	gl_FragData[0] = pow(_lhs - _rhs, vec4(2.0));
}
