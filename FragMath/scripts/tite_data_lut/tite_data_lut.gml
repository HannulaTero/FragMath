

/// @func	tite_data_lut(_params);
/// @desc	Creates new lookup data for lut-opreations
/// @param	{Struct} _params	Parameters for creating data. Check init function.
/// @return	{Struct.TiteDataLut}
function tite_data_lut(_params)
{
	tite_forceinline;
	var _data = new TiteDataLut(); 
	return tite_data_lut_init(_data, _params);
}


/// @func	tite_data_lut_init(_dst, _params);
/// @desc	Initializes lookup data, prepares the buffer.
/// @param	{Struct.TiteDataLut}	_dst
/// @param	{Struct}				_params
/// @return	{Struct.TiteDataLut}
function tite_data_lut_init(_dst, _params={})
{
	// Get the parameters.
	_dst.rangeMin = _params[$ "rangeMin"] ?? 0.0;
	_dst.rangeMax = _params[$ "rangeMax"] ?? 1.0;
	_dst.func = _params[$ "func"] ?? function(_lhs) { return _lhs; };
	var _buffer = _params[$ "buffer"];
	var _width = _params[$ "width"];
		
	// Initialize the GPU data.
	_width ??= ceil(abs(_dst.rangeMax - _dst.rangeMin));
	tite_data_init(_dst, _width, 1, _params);
	
	// Initialize buffer in CPU side.
	var _dsize = tite_format_bytes(_dst.format);
	var _bytes = _dsize * _dst.count;
	_dst.buffer = buffer_create(_bytes, buffer_fixed, 1);
	
	// Fill the buffer data.
	if (_buffer != undefined) 
	{
		// Copy pre-existing buffer data.
		//  -> Assumed to be correct width!
		buffer_copy(_buffer, 0, _bytes, _dst.buffer, 0);
	}
	else
	{
		// Preparations.
		var _min = _dst.rangeMin;
		var _max = _dst.rangeMax;
		var _div = 1.0 / (_dst.count - 1);
		var _dtype = tite_format_buffer_dtype(_dst.format);
		var _components = tite_format_components(_dst.format);
		buffer_seek(_dst.buffer, buffer_seek_start, 0);
		
		// Generate buffer data.
		for(var i = 0.0; i < _dst.count; i++)
		{
			var _lhs = lerp(_min, _max, i * _div);
			var _out = _dst.func(_lhs);
			repeat(_components) 
			{
				buffer_write(_dst.buffer, _dtype, _out);
			}
		}
	}
		
	return _dst;
}


/// @func	tite_data_lut_surface(_src);
/// @desc	Returns lookup surface, makes sure it exists and is up to date.
/// @param	{Struct.TiteDataLut} _src
/// @return	{Id.Surface}
function tite_data_lut_surface(_src)
{
	var _surf = tite_data_surface(_src);
	if (buffer_exists(_src.buffer))
		buffer_set_surface(_src.buffer, _surf, 0);
	else
		tite_warning("TiteDataLut buffer not initialized.");
	return _surf;
}


/// @func	tite_data_lut_free(_data);
/// @desc	Removes surface and buffer for lookup data.
/// @param	{Struct.TiteDataLut} _data
function tite_data_lut_free(_data)
{
	tite_data_free(_data);
	if (buffer_exists(_data.buffer))
		buffer_delete(_data.buffer);
	return _data;
}





