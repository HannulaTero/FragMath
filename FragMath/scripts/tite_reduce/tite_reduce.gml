

/// @func	tite_reduce(_out, _src, _op2x2, _opMxN);
/// @desc	Reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
/// @param	{Asset.GMShader} _op2x2
/// @param	{Asset.GMShader} _opMxN
/// @param	{Any} _default
function tite_reduce(_out, _src, _op2x2, _opMxN, _default=undefined)
{ 
	// Preparations.
	var _w = _src.size[0];
	var _h = _src.size[1];
	var _tempSrc = _src.Clone(true);
	var _tempDst;
	var _params = { format : _src.format };
	
	// Do 2x2 sum-reduces.
	tite_begin();
	tite_shader(_op2x2);
	while(min(_w, _h) > 2)
	{
		_w = ceil(_w / 2);
		_h = ceil(_h / 2);
		_tempDst = new TiteData(_w, _h, _params);
		tite_sample("texA", _tempSrc);
		tite_floatN("uniTexelA", _tempSrc.texel);
		tite_target(_tempDst);
		tite_render();
		tite_finish();
		_tempSrc.Free();
		_tempSrc = _tempDst;
	}
	tite_end();
	
	// Finish with MxN reduction for non-rectangulars.
	tite_begin();
	tite_shader(_opMxN);
	tite_sample("texA", _tempSrc);
	tite_floatN("uniTexelA", _tempSrc.texel);
	tite_float2("uniRange", _w, _h);
	tite_float4_any("uniDefault", _default);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	_tempSrc.Free();
	return _out;
}


/// @func	tite_reduce_sum(_out, _src);
/// @desc	Sum-reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
function tite_reduce_sum(_out, _src)
{
	return tite_reduce(_out, _src, tite_op_reduce_sum2x2, tite_op_reduce_sumMxN);
}


/// @func	tite_reduce_mean(_out, _src);
/// @desc	Mean-reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
function tite_reduce_mean(_out, _src)
{
	return tite_reduce(_out, _src, tite_op_reduce_mean2x2, tite_op_reduce_meanMxN);
}


/// @func	tite_reduce_max(_out, _src);
/// @desc	Max-reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
function tite_reduce_max(_out, _src)
{
	return tite_reduce(_out, _src, tite_op_reduce_max2x2, tite_op_reduce_maxMxN, -infinity);
}


/// @func	tite_reduce_min(_out, _src);
/// @desc	Min-reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
function tite_reduce_min(_out, _src)
{
	return tite_reduce(_out, _src, tite_op_reduce_min2x2, tite_op_reduce_minMxN, infinity);
}




