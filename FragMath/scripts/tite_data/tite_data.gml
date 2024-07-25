// feather ignore GM2017

/// @func	tite_data(_params);
/// @desc	Creates new datastructure for holding GPU data, matrix-like.
/// @param	{Struct}	_params		Parameters for creating data. Check init function.
/// @return	{Struct.TiteData}
function tite_data(_params=undefined) 
{
	tite_forceinline;
	return tite_data_init(new TiteData(), _params);
}


/// @func	tite_data_init(_dst, _params);
/// @desc	(Re)Initializes data with given parameters.
/// @param	{Struct.TiteData}	_dst
/// @param	{Struct}			_params
/// @return	{Struct.TiteData}
function tite_data_init(_dst, _params={})
{
	tite_forceinline;
	
	// Optional parameters.
	_dst.name = _params[$ "name"] ?? _dst.name;
	_dst.format	= _params[$ "format"] ?? _dst.format;
	_dst.repetive = _params[$ "repetive"] ?? _dst.repetive;
	_dst.interpolate = _params[$ "interpolate"] ?? _dst.interpolate;
	_dst.depthDisabled = _params[$ "depthDisabled"] ?? _dst.depthDisabled;
	
	// Handle translation.
	_dst.format	= tite_format_get(_dst.format);
	
	// Prepare the gpu data.
	tite_data_resize(_dst, _params);
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


/// @func	tite_data_resize(_data, _params);
/// @desc	Get mew size, there are multiple ways.
/// @param	{Struct.TiteData} _data
/// @param	{Any} _params
function tite_data_resize(_data, _params)
{
	tite_forceinline;
	
	// Preparations.
	tite_data_free(_data);
	var _size = variable_clone(_data.size);
	var _count = undefined;
	
	// Params from array.
	if (is_array(_params))
	{
		var _length = min(2, array_length(_params));
		array_copy(_size, 0, _params, 0, _length);
	}
	
	// Params from struct.
	if (is_struct(_params))
	{
		if (struct_exists(_params, "size"))
			_size = tite_resize_power2(_params.size);
	
		if (struct_exists(_params, "width"))
			_size[0] = _params.width;	
	
		if (struct_exists(_params, "height"))
			_size[1] = _params.height;
			
		if (struct_exists(_params, "count"))
			_count = _params.count;
	}
	
	// Clamp up the size.
	_data.size[0] = clamp(ceil(_size[0]), 1, 16384);
	_data.size[1] = clamp(ceil(_size[1]), 1, 16384);
		
	// Give warning if size was not valid.
	if (_data.size[0] != _size[0]) 
	|| (_data.size[1] != _size[1])
	{
		tite_warning(
			+ $"TiteData {_data.name} Resize: \n"
			+ $" - Non-valid size: {_size} \n"
			+ $" - Changed into:   {_data.size} "
		);
	}
	
	// Give warning if explicit count doesn't fit.
	var _maxCount = _data.size[0] * _data.size[1];
	if (_count != undefined)
	&& (_count > _maxCount)
	{
		tite_warning(
			+ $"TiteData {_data.name} Resize: \n"
			+ $" - Non-valid count: {_count} \n"
			+ $" - Changed into:    {_maxCount} "
		);
	}
	_data.count = _count ?? _maxCount;
		
	// Set up texel size.
	_data.texel[0] = 1.0 / _data.size[0];
	_data.texel[1] = 1.0 / _data.size[1];
	
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
