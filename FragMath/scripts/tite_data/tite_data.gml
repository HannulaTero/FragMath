// feather ignore GM2017

/// @func	tite_data(_width, _height, _params);
/// @desc	Creates new datastructure for holding GPU data, matrix-like.
/// @param	{Real}		_width
/// @param	{Real}		_height
/// @param	{Struct}	_params		Parameters for creating data. Check init function.
/// @return	{Struct.TiteData}
function tite_data(_width, _height, _params) 
{
	tite_forceinline;
	var _data = new TiteData(); 
	return tite_data_init(_data, _width, _height, _params);
}


/// @func	tite_data_init(_dst, _width, _height, _params);
/// @desc	(Re)Initializes data with given parameters.
/// @param	{Struct.TiteData}	_dst
/// @param	{Real}				_width
/// @param	{Real}				_height
/// @param	{Struct}			_params
/// @return	{Struct.TiteData}
function tite_data_init(_dst, _width=1, _height=1, _params={})
{
	tite_forceinline;
	
	// Optional parameters.
	_dst.name = _params[$ "name"] ?? _dst.name;
	_dst.format	= _params[$ "format"] ?? _dst.format;
	_dst.repetive = _params[$ "repetive"] ?? _dst.repetive;
	_dst.interpolate = _params[$ "interpolate"] ?? _dst.interpolate;
	_dst.depthDisabled = _params[$ "depthDisabled"] ?? _dst.depthDisabled;
	
	// Prepare the gpu data.
	if (is_string(_dst.format))
		_dst.format = tite_format_get_string(_dst.format);
	_dst.format	= tite_format_get_compatible(_dst.format);
	tite_data_resize(_dst, _width, _height);
	return _dst;
}


/// @func	tite_data_copy(_dst, _src, _copyContent);
/// @desc	Copies structure and optionally contents to another data.
/// @param	{Struct.TiteData}	_dst
/// @param	{Struct.TiteData}	_src
/// @param	{Bool}				_copyContent
/// @return	{Struct.TiteData}
function tite_data_copy(_dst, _src, _copyContent=false)
{
	tite_forceinline;
	_dst.size[0] = _src.size[0];
	_dst.size[1] = _src.size[1];
	_dst.texel[0] = _src.texel[0];
	_dst.texel[1] = _src.texel[1];
	_dst.count = _src.count;
	_dst.format = _src.format;
	_dst.repetive = _src.repetive;
	_dst.interpolate = _src.interpolate;
	if (_copyContent)
	{
		tite_begin();
		var _surfDst = tite_data_surface(_dst);
		var _surfSrc = tite_data_surface(_src);
		surface_copy(_surfDst, 0, 0, _surfSrc);
		tite_end();
	}
	return _dst;
}


/// @func	tite_data_surface(_src);
/// @desc	Return surface of the data, creates if necessary.
/// @param	{Struct.TiteData}	_src
/// @return	{Id.Surface}
function tite_data_surface(_src)
{
	tite_forceinline;
	
	// Make sure surface is correct shape.
	if (surface_exists(_src.surface))
	{
		if (surface_get_width(_src.surface) != _src.size[0])
		|| (surface_get_height(_src.surface) != _src.size[1])
		|| (surface_get_format(_src.surface) != _src.format)
			surface_free(_src.surface); // Force recreation.
	}
		
	// Make sure surface exists.
	if (!surface_exists(_src.surface))
	{
		var _depthDisabled = surface_get_depth_disable();
		surface_depth_disable(_src.depthDisabled);
		_src.surface = surface_create(_src.size[0], _src.size[1], _src.format);
		surface_depth_disable(_depthDisabled);
	}
		
	return _src.surface;
}


/// @func	tite_data_resize(_data, _w, _h);
function tite_data_resize(_data, _w, _h=1)
{
	tite_forceinline;
	tite_data_free(_data);
	
	// Set up the size.
	_data.size[0] = clamp(ceil(_w), 1, 16384);
	_data.size[1] = clamp(ceil(_h), 1, 16384);
		
	// Set up texel size.
	_data.texel[0] = 1.0 / _data.size[0];
	_data.texel[1] = 1.0 / _data.size[1];
	_data.count = _data.size[0] * _data.size[1];
		
	// Give warning if size was not valid.
	if (_data.size[0] != _w) || (_data.size[1] != _h)
	{
		tite_warning(
			+ $"TiteData {_data.name} Resize: \n"
			+ $" - Non-valid size: [{_w}, {_h}] \n"
			+ $" - Changed into:   {_data.size} "
		);
	}
	return _data;
}


/// @func	tite_data_exists(_data);
/// @desc	Checks whether data exists in gpu.
/// @param	{Struct.TiteData} _data
/// @return	{Bool}
function tite_data_exists(_data)
{
	tite_forceinline;
	if (_data == undefined) return false;
	return surface_exists(_data.surface);
}


/// @func	tite_data_free(_data);
/// @desc	Frees surface in the data.
/// @param	{Struct.TiteData} _data
/// @return	{Struct.TiteData}
function tite_data_free(_data)
{
	tite_forceinline;
	if (surface_exists(_data.surface))
		surface_free(_data.surface);
	return _data;
}
