precision highp float;

varying vec4 vDataValue;

void main()
{
	gl_FragData[0] = vDataValue;
}
