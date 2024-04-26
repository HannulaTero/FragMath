// feather ignore GM2017

/// @func	tite_lut(_out, _src, _lut);
/// @desc	Look up table opeation to select new value.
/// @param	{Struct.TiteData}	_out
/// @param	{Struct.TiteData}	_src
/// @param	{Struct.TiteGpuLookup}	_lut
function tite_lut(_out, _src, _lut) 
{
	// Trying to do in-place operation.
	if (_out == _src)
		return tite_inplace(tite_lut, [_out, _src, _lut]);
	
	// Preparations. Precompute range remapping factors.
	var _factorX = _lut.rangeMin;
	var _factorY = 1.0 / (_lut.rangeMax - _lut.rangeMin);
	
	// Whether do operation for each component separately.
	var _components = tite_format_components(_src.format);
	var _shader = (_components == 4)
		? tite_op_lut4
		: tite_op_lut1;
	
	// Do the computation.
	tite_begin();
	tite_shader(_shader);
	tite_sample("texA", _src);
	tite_sample("texLUT", _lut);
	tite_floatN("uniTexelA", _src.texel);
	tite_floatN("uniTexelLUT", _lut.texel);
	tite_float2("uniFactor", _factorX, _factorY);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


