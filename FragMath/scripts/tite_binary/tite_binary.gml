// feather ignore GM2017

/// @func	tite_binary(_out, _lhs, _rhs, _op);
/// @desc	Do operation with two inputs, store result into output.
/// @param	{Struct.TiteData}	_out
/// @param	{Struct.TiteData}	_lhs
/// @param	{Struct.TiteData}	_rhs
/// @param	{Asset.GMShader}	_op		Tite math shader.
function tite_binary(_out, _lhs, _rhs, _op) 
{
	// Trying to do in-place operation.
	if (_out == _lhs) || (_out == _rhs)
		return tite_inplace(tite_binary, [_out, _lhs, _rhs, _op]);
		
	// Do the computation.
	tite_begin();
	tite_shader(_op);
	tite_sample("texA", _lhs);
	tite_sample("texB", _rhs);
	tite_floatN("uniTexelA", _lhs.texel);
	tite_floatN("uniTexelB", _rhs.texel);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}



