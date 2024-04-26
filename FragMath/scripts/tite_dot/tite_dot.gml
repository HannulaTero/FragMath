// feather ignore GM2017

/// @func	tite_dot(_out, _lhs, _rhs, _axis);
/// @desc	Do dot product between to matrices with given axis.
/// @param	{Struct.TiteData}	_out
/// @param	{Struct.TiteData}	_lhs
/// @param	{Struct.TiteData}	_rhs
/// @param	{Array<Real>}			_axis	Which dimension is sumreduced.
function tite_dot(_out, _lhs, _rhs, _axis=[1, 0])
{
	// Trying to do in-place operation.
	if (_out == _lhs) || (_out == _rhs)
		return tite_inplace(tite_dot, [_out, _lhs, _rhs, _axis]);
		
	// Check target axis compatibility.
	if (_lhs.size[_axis[0]] != _rhs.size[_axis[1]])
	{
		tite_error(
			+ $"Dot product: target axis do not match. \n"
			+ $" - Given target axis: {_lhs.size[_axis[0]]} and {_rhs.size[_axis[1]]}\n"
			+ $" - Operators:\n - {_lhs.name} : {_lhs.size}\n - {_rhs.name} : {_rhs.size}\n"
		);
	}
	
	// Check whether dimensionality is correct.
	if (_out.size[0] != _lhs.size[!_axis[0]])
	|| (_out.size[1] != _rhs.size[!_axis[1]])
	{
		tite_error(
			+ $"Dot product: output size is incorrect. \n"
			+ $" - Output size was: {_out.size} \n"
			+ $" - Output should be: [{_lhs.size[!_axis[0]]}, {_rhs.size[!_axis[1]]}]"
		);
	}
		
	// Find non-iterable axis, those which weren't selected.
	// These will keep their position. 
	var _startA = [
		(_axis[0] != 0), 
		(_axis[0] != 1)
	];
	
	var _startB = [
		(_axis[1] != 0), 
		(_axis[1] != 1)
	];
	
	// Find iterable axis, and get their stepping size.
	var _stepsA = [
		(_startA[0] ? 0.0 : _lhs.texel[0]), 
		(_startA[1] ? 0.0 : _lhs.texel[1])
	];
	
	var _stepsB = [
		(_startB[0] ? 0.0 : _rhs.texel[0]), 
		(_startB[1] ? 0.0 : _rhs.texel[1])
	];
	
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_dot);
	tite_sample("texA", _lhs);
	tite_sample("texB", _rhs);
	tite_floatN("uniTexelA", _lhs.texel);
	tite_floatN("uniTexelB", _rhs.texel);
	tite_floatN("uniStartA", _startA);
	tite_floatN("uniStartB", _startB);
	tite_floatN("uniStepsA", _stepsA);
	tite_floatN("uniStepsB", _stepsB);
	tite_float1("uniIterations", _lhs.size[_axis[0]]);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}
