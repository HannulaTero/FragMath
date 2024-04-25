precision highp float;

uniform sampler2D texA;
uniform vec2 uniTexelA;

// Min-reduces 2x2 area.
void main() {	
	vec2 _position = floor(gl_FragCoord.xy) * 2.0 + 0.5;
	gl_FragData[0] = min(
		texture2D(texA, (_position + vec2(0.0, 0.0)) * uniTexelA), min(
		texture2D(texA, (_position + vec2(0.0, 1.0)) * uniTexelA), min(
		texture2D(texA, (_position + vec2(1.0, 0.0)) * uniTexelA),
		texture2D(texA, (_position + vec2(1.0, 1.0)) * uniTexelA)
	)));
}

