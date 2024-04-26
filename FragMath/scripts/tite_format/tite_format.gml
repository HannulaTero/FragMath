
/// @func	tite_format_get_compatible(_format);
/// @desc	Find supported format which resembles closest to given format. 
/// @param	{Constant.SurfaceFormatType} _format	
function tite_format_get_compatible(_format)
{
	tite_forceinline;
	
	// Map out replacement, if given format is not suitable.
	// Assumes rgba8unorm is always accepted.
	static __map = tite_mapping([
		surface_rgba32float,	surface_rgba16float,
		surface_rgba16float,	surface_rgba8unorm,
		surface_r32float,		surface_r16float,
		surface_r16float,		surface_r8unorm,
		surface_rgba4unorm,		surface_rgba8unorm,	
		surface_rg8unorm,		surface_rgba8unorm,	
		surface_r8unorm,		surface_rgba8unorm,	
		surface_rgba8unorm,		surface_rgba8unorm	// Lowest nominator.
	]);
	
	// Try find best compatible format.
	var _select = _format;
	while(!surface_format_is_supported(_select))
	{
		_select = __map[$ _format] ?? surface_rgba8unorm;
	}
		
	// Give warning of different selected format.
	if (_select != _format)
	{
		tite_warning(
			+ $"Format {tite_format_name(_format)} not supported. \n"
			+ $" - Selected format {tite_format_name(_select)} instead."
		);
	}
	
	// Return the selected format
	return _select;
}


/// @func	tite_format_name(_format);
/// @desc	Format names.
/// @param	{Constant.SurfaceFormatType} _format	
function tite_format_name(_format)
{
	tite_forceinline;
	static __map = tite_mapping([
		surface_rgba32float,	"RGBA32Float",
		surface_rgba16float,	"RGBA16Float",
		surface_rgba8unorm,		"RGBA8Unorm",
		surface_rgba4unorm,		"RGBA4Unorm",
		surface_rg8unorm,		"RG8Unorm",
		surface_r8unorm,		"R8Unorm",
		surface_r32float,		"R32Float",
		surface_r16float,		"R16Float"
	]);
	return __map[$ _format] ?? "<unknown surface format>";
}


/// @func	tite_format_get_string(_string);
/// @desc	Get data format from string.
/// @param	{String} _string
/// @return	{Constant.SurfaceFormatType}
function tite_format_get_string(_string)
{
	tite_forceinline;
	static __map = tite_mapping([
		"rgba32float",	surface_rgba32float,	
		"rgba16float",	surface_rgba16float,	
		"rgba8unorm",	surface_rgba8unorm,		
		"rgba4unorm",	surface_rgba4unorm,		
		"rg8unorm",		surface_rg8unorm,		
		"r8unorm",		surface_r8unorm,		
		"r32float",		surface_r32float,		
		"r16float",		surface_r16float,		
	]);
	_string = string_lower(_string);
	return __map[$ _string] ?? surface_rgba8unorm;
}


/// @func	tite_format_components(_format);
/// @desc	How many components format has.
/// @param	{Constant.SurfaceFormatType} _format	
function tite_format_components(_format)
{
	tite_forceinline;
	static __map = tite_mapping([
		surface_rgba32float,	4,
		surface_rgba16float,	4,
		surface_rgba8unorm,		4,
		surface_rgba4unorm,		4,
		surface_rg8unorm,		2,
		surface_r8unorm,		1,
		surface_r32float,		1,
		surface_r16float,		1
	]);
	return __map[$ _format] ?? 4;
}


/// @func	tite_format_bytes(_format);
/// @desc	How many bytes format takes per element.
/// @param	{Constant.SurfaceFormatType} _format	
function tite_format_bytes(_format)
{
	tite_forceinline;
	static __map = tite_mapping([
		surface_rgba32float,	4 * 4,
		surface_rgba16float,	4 * 2,
		surface_rgba8unorm,		4 * 1,
		surface_rgba4unorm,		4 * 0.5,
		surface_rg8unorm,		2 * 1,
		surface_r8unorm,		1 * 1,
		surface_r32float,		1 * 4,
		surface_r16float,		1 * 2
	]);
	return __map[$ _format] ?? 4;
}


/// @func	tite_format_buffer_dtype(_format);
/// @desc	Get buffer datatype which represents format.
/// @param	{Constant.SurfaceFormatType} _format	
function tite_format_buffer_dtype(_format)
{
	tite_forceinline;
	static __map = tite_mapping([
		surface_rgba32float,	buffer_f32,
		surface_rgba16float,	buffer_f16,
		surface_r32float,		buffer_f32,
		surface_r16float,		buffer_f16
	]);
	return __map[$ _format] ?? buffer_u8;
}


/// @func	tite_buffer_dtype_format(_dtype);
/// @desc	Get surface format representable by buffer dtype.
/// @param	{Constant.BufferDataType} _dtype	
function tite_buffer_dtype_format(_dtype)
{
	tite_forceinline;
	static __map = tite_mapping([
		buffer_f32,		surface_rgba32float,
		buffer_f16,		surface_rgba16float,
		buffer_u8,		surface_rgba8unorm,
	]);
	return __map[$ _dtype] ?? surface_rgba8unorm;
}

