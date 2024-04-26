/// @desc DO CPU CALCULATION
// feather ignore GM2017

// Preparations.
var _lhsW = lhsGpu.size[0];
var _rhsW = lhsGpu.size[0];
var _outW = outGpu.size[0];
var _outH = outGpu.size[1];
var _axis = lhsGpu.size[1]; // or rhsGpu.size[0]
	
// Calculate.
var j = axis;
for(var i = 0; i < _outW; i++) {	
	var _sum = 0;
	for(var k = 0; k < _axis; k++)
	{
		var _lhs = buffer_peek(lhsCpu, (i + k * _lhsW) * dsize, dtype);
		var _rhs = buffer_peek(rhsCpu, (k + j * _rhsW) * dsize, dtype);
		_sum += _lhs * _rhs;
	}
	buffer_poke(outCpu, (i + j * _outW) * dsize, dtype, _sum);
}	

// Whether continue calculation.
axis++;
show_debug_message($"CPU calculation progress {(axis / _outH) * 100.0} %");
if (axis < _outH)
{
	alarm[0] = 1;
}