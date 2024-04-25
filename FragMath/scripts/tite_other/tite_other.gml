
/// @func	tite_clamp(_out, _src, _min, _max);
/// @desc	Clamping function. 
/// @param	{Struct.TiteData}	_out
/// @param	{Struct.TiteData}	_src
/// @param	{Any}				_min
/// @param	{Any}				_max
function tite_clamp(_out, _src, _min=undefined, _max=undefined)
{
	// Trying to do in-place operation.
	if (_out == _src)
		return tite_inplace(tite_clamp, [_out, _src, _min, _max]);
		
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_clamp);
	tite_sample("texA", _src);
	tite_floatN("uniTexelA", _src.texel);
	tite_float4_any("uniMin", _min ?? 0);
	tite_float4_any("uniMax", _max ?? 1);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_mix(_out, _lhs, _rhs, _rate);
/// @desc	Lerping/mixing function. 
/// @param	{Struct.TiteData}	_out
/// @param	{Struct.TiteData}	_lhs
/// @param	{Struct.TiteData}	_rhs
/// @param	{Any}				_rate
function tite_mix(_out, _lhs, _rhs, _rate=undefined)
{
	// Trying to do in-place operation.
	if (_out == _lhs)
		return tite_inplace(tite_mix, [_out, _lhs, _rhs, _rate]);
		
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_mix);
	tite_sample("texA", _lhs);
	tite_sample("texB", _rhs);
	tite_floatN("uniTexelA", _lhs.texel);
	tite_floatN("uniTexelB", _rhs.texel);
	tite_float4_any("uniRate", _rate ?? 0.5);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_offset(_out, _src, _offset);
/// @desc	Do operation with one inputs, store result into output.
/// @param	{Struct.TiteData}	_out
/// @param	{Struct.TiteData}	_src
/// @param	{Any}				_offset
function tite_offset(_out, _src, _offset=undefined)
{
	// Trying to do in-place operation.
	if (_out == _src)
		return tite_inplace(tite_offset, [_out, _src, _offset]);
		
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_offset);
	tite_sample("texA", _src);
	tite_floatN("uniTexelA", _src.texel);
	tite_float4_any("uniOffset", _offset ?? 0.0);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_scale(_out, _src, _scale);
/// @desc	Do operation with one inputs, store result into output.
/// @param	{Struct.TiteData}	_out
/// @param	{Struct.TiteData}	_src
/// @param	{Any}				_scale
function tite_scale(_out, _src, _scale=undefined)
{
	// Trying to do in-place operation.
	if (_out == _src)
		return tite_inplace(tite_scale, [_out, _src, _scale]);
	
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_scale);
	tite_sample("texA", _src);
	tite_floatN("uniTexelA", _src.texel);
	tite_float4_any("uniScale", _scale ?? 1.0);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_normalize(_out, _src, _min, _max);
/// @desc	Normalizes the values into given range. Doesn't clamp.
/// @param	{Struct.TiteData}	_out
/// @param	{Struct.TiteData}	_src
/// @param	{Any}				_min
/// @param	{Any}				_max
function tite_normalize(_out, _src, _min=undefined, _max=undefined)
{
	// Trying to do in-place operation.
	if (_out == _src)
		return tite_inplace(tite_normalize, [_out, _src, _min, _max]);
		
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_normalize);
	tite_sample("texA", _src);
	tite_floatN("uniTexelA", _src.texel);
	tite_float4_any("uniMin", _min);
	tite_float4_any("uniMax", _max);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_set(_out, _values);
/// @desc	Set whole surface to specific value.
/// @param	{Struct.TiteData}	_out
/// @param	{Any}				_values
function tite_set(_out, _values=undefined)
{
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_set);
	tite_float4_any("uniOffset", _values ?? 0);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_index1D(_out);
/// @desc	Set data values to be their 1D index values (mind precision!).
/// @param	{Struct.TiteData} _out
function tite_index1D(_out)
{
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_index1D);
	tite_floatN("uniSize", _out.size);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_index2D(_out);
/// @desc	Set data values to be their 2D index values (mind precision!).
/// @param	{Struct.TiteData} _out
function tite_index2D(_out)
{
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_index2D);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_color_lab(_out, _src);
/// @desc	Changes color space into LAB.
/// @param	{Struct.TiteData} _out
/// @param	{Struct.TiteData} _src
function tite_color_lab(_out, _src)
{
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_lab);
	tite_sample("texA", _src);
	tite_floatN("uniTexelA", _src.texel);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_swizzle(_out, _r, _g, _b, _a);
/// @desc	Swizzle around values by given index.
/// @param	{Struct.TiteData} _out
/// @param	{Real} _r
/// @param	{Real} _g
/// @param	{Real} _b
/// @param	{Real} _a
function tite_swizzle(_out, _r=0, _g=1, _b=2, _a=3)
{
	// Do the computation.
	tite_begin();
	tite_shader(tite_op_swizzle);
	tite_integer("uniR", _r);
	tite_integer("uniG", _g);
	tite_integer("uniB", _b);
	tite_integer("uniA", _a);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_randomize(_out, _min, _max, _seedX, _seedY);
/// @desc	Randomizes the target. Computes randomization in shader!
/// @param	{Struct.TiteData} _out
/// @param	{Any} _min
/// @param	{Any} _max
/// @param	{Any} _seedX
/// @param	{Any} _seedY
function tite_randomize(_out, _min=undefined, _max=undefined, _seedX=undefined, _seedY=undefined)
{ 
	_seedX ??= (get_timer() mod 2777) / 2777.0;
	_seedY ??= (get_timer() mod 1097) / 1097.0;
	tite_begin();
	tite_shader(tite_op_randomize);
	tite_floatN("uniTexelA", _out.texel);
	tite_float4_any("uniMin", _min ?? 0);
	tite_float4_any("uniMax", _max ?? 0);
	tite_float4_any("uniSeedX", _seedX);
	tite_float4_any("uniSeedY", _seedY);
	tite_float4("uniFactor", 2.12, 2.34, 2.56, 2.78);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_random_tex();
/// @desc	Returns premade randomization texture.
function tite_random_tex()
{
	TITE.randData ??= new TiteData(TITE.randSize[0], TITE.randSize[0], {
		format: tite_buffer_dtype_format(TITE.randDtype)
	});
	if (!TITE.randData.Exists())
		TITE.randData.FromBuffer(TITE.randBuff);
	return TITE.randData;
}



