// feather ignore GM2017

/// @func	tite_draw(_src, _x, _y, _params);
/// @desc	Draws gpu datablock with given parameters.
/// @param	{Struct.TiteData} _src
/// @param	{Real}		_x
/// @param	{Real}		_y
/// @param	{Struct}	_params	[Optional]
function tite_draw(_src, _x=0, _y=0, _params={}) 
{
	// Get the uniforms.
	tite_forceinline;
	static __shader = tite_shd_visualize;
	static __uniFactor = shader_get_uniform(__shader, "uniFactor");
		
	// Get parameters for drawing.
	var _w			= _params[$ "width"]		?? _src.size[0];
	var _h			= _params[$ "height"]		?? _src.size[1];
	var _halign		= _params[$ "halign"]		?? 0.0;
	var _valign		= _params[$ "valign"]		?? 0.0;
	var _outline	= _params[$ "outline"]		?? false;
	var _background	= _params[$ "background"]	?? false;
	var _normalize	= _params[$ "normalize"]	?? false;
	var _rangeMin	= _params[$ "rangeMin"]		?? 0.0;
	var _rangeMax	= _params[$ "rangeMax"]		?? 1.0;
	var _filter		= _params[$ "filter"]		?? false;
	var _blend		= _params[$ "blend"]		?? false;
	
	// Calculate positions, size and offsets
	_w *= _params[$ "xscale"] ?? 1.0;
	_h *= _params[$ "yscale"] ?? 1.0;
	_x -= _w * _halign;
	_y -= _h * _valign;
	
	// Set gpu settings.
	tite_begin();
	gpu_set_blendenable(_blend);
	gpu_set_blendmode(bm_normal);
	gpu_set_tex_filter(_filter);
	
	// Draw background for surface.
	if (_background)
	{
		var _c = c_black;
		draw_rectangle_color(_x, _y, _x+_w, _y+_h, _c,_c,_c,_c, false);
	}
		
	// Whether remap values into. 
	// Useful for visualizing float textures.
	if (_normalize)
	{
		shader_set(__shader);
		shader_set_uniform_f(__uniFactor, _rangeMin, _rangeMax);
		draw_surface_stretched(_src.Surface(), _x, _y, _w, _h);
		shader_reset();
	} 
	else 
	{
		draw_surface_stretched(_src.Surface(), _x, _y, _w, _h);
	}
		
	// Draw outline around the surface.
	if (_outline)
	{
		var _c = c_white;
		draw_rectangle_color(_x, _y, _x+_w, _y+_h, _c,_c,_c,_c, true);
	}
	
	tite_end();
	return _src;
}



