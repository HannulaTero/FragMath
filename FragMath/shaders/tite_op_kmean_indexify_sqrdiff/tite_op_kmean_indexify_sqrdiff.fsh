precision highp float;

uniform sampler2D texDim; 
uniform vec2 uniTexelDim;

uniform sampler2D texClusters;
uniform vec2 uniTexelClusters;
uniform vec2 uniClusterIndex;

void main()
{
	vec4 lhs = texture2D(texDim, gl_FragCoord.xy * uniTexelDim);
	vec4 rhs = texture2D(texClusters, (uniClusterIndex + 0.5) * uniTexelClusters);
	vec4 sqr = pow(lhs - rhs, vec4(2.0));
	float dist = (sqr.x + sqr.y + sqr.z + sqr.w);
	gl_FragData[0].r = dist;
}
