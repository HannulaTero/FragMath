// feather ignore GM2017

/// @func	tite_reduce(_out, _src, _InitialValues, _BlendSettings);
/// @desc	Reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out		
/// @param	{Struct.TiteData} _src		
/// @param	{Real} _initialValue		Initial value for destination.
/// @param	{Function} _BlendSettings	Function to change blend settings.
function tite_reduce(_out, _src, _initialValue, _BlendSettings)
{
	// Helper function.
	static render_part = function(_data, _x, _y, _w, _h)
	{
		draw_surface_part(_data.Surface(), _x, _y, _w, _h, 0, 0);
	};
	
	// Preparations.
	var _w = _src.size[0];
	var _h = _src.size[1];
	var _tempA = _src.Clone(true);
	var _tempB = _src.Clone(false);
	var _tempC;
	tite_set(_tempB, _initialValue);
	tite_begin();
	gpu_set_blendenable(true);
	_BlendSettings();
	
	// Pre-reduce to nearest power of 2.
	var _logW = sqr(floor(log2(_w)));
	var _logH = sqr(floor(log2(_h)));
	var _diffW = (_w - _logW);
	var _diffH = (_h - _logH);
	tite_target(_tempB);
	render_part(_tempA, _logW, 0, _diffW, _h);
	render_part(_tempA, 0, _logH, _w, _diffH);
	render_part(_tempA, _logW, _logH, _diffW, _diffH);
	tite_finish();
	_w = _logW;
	_h = _logH;
	
	// Reduce by factor of 2's.
	while(min(_w, _h) > 2)
	{
		_w = ceil(_w / 2);
		_h = ceil(_h / 2);
		tite_target(_tempB);
		render_part(_tempA, 0, 0, _w, _h);
		render_part(_tempA, _w, 0, _w, _h);
		render_part(_tempA, 0, _h, _w, _h);
		render_part(_tempA, _w, _h, _w, _h);
		tite_finish();
		_tempC = _tempB;
		_tempB = _tempA;
		_tempA = _tempC;
	}
	tite_end();
	
	// Copy results.
	tite_begin();
	tite_target(_out);
	render_part(_tempC, 0, 0, 1, 1);
	tite_finish();
	tite_end();
	
	// Finalize.
	tite_data_free(_tempA);
	tite_data_free(_tempB);
	return _out;
}


/// @func	tite_reduce_sum(_out, _src);
/// @desc	Sum-reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
function tite_reduce_sum(_out, _src)
{
	return tite_reduce(_out, _src, 0, function()
	{
		gpu_set_blendmode_ext(bm_one, bm_one);
	});
}


/// @func	tite_reduce_mean(_out, _src);
/// @desc	Mean-reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
function tite_reduce_mean(_out, _src)
{
	tite_reduce(_out, _src, 0, function()
	{
		gpu_set_blendmode_ext(bm_one, bm_one);
	});
	return tite_divide(_out, _out, _out.count);
}


/// @func	tite_reduce_max(_out, _src);
/// @desc	Max-reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
function tite_reduce_max(_out, _src)
{
	return tite_reduce(_out, _src, -infinity, function()
	{
		gpu_set_blendmode_ext(bm_one, bm_one);
		gpu_set_blendequation(bm_eq_max);
	});
}


/// @func	tite_reduce_min(_out, _src);
/// @desc	Min-reduces source into single value (1x1).
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
function tite_reduce_min(_out, _src)
{
	return tite_reduce(_out, _src, infinity, function()
	{
		gpu_set_blendmode_ext(bm_one, bm_one);
		gpu_set_blendequation(bm_eq_min);
	});
}


/* Previous version with shaders.


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




