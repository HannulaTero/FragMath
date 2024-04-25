

/// @func	tite_begin();
/// @desc	Changes gpu states to more suitable for calculations.
function tite_begin()
{
	tite_forceinline;
	
	// Set up gpu states.
	gpu_push_state();
	gpu_set_alphatestenable(false);
	gpu_set_tex_filter(false);
	gpu_set_tex_repeat(false);
	array_push(TITE.previousShader, shader_current());
	
	// Set cumulative results with blend mode.
	if (TITE.cumulative) 
	{
		gpu_set_blendenable(true);
		gpu_set_blendmode_ext(bm_one, bm_one);
	} 
	else 
	{
		gpu_set_blendenable(false);
		gpu_set_blendmode_ext(bm_one, bm_zero);
	}
}


/// @func	tite_end();
/// @desc	Returns previous gpu state. Removes cumulativity.
function tite_end()
{
	tite_forceinline;
	gpu_pop_state();
	var _shader = array_pop(TITE.previousShader);
	if (_shader != -1)
		shader_set(_shader);
	else
		shader_reset();
	TITE.cumulative = false;
}


/// @func	tite_shader(_shader);
/// @desc	Select tite operation.
/// @param	{Asset.GMShader} _shader
function tite_shader(_shader) 
{
	tite_forceinline;
	shader_set(_shader);
}


/// @func	tite_set_cumulative(_additive);
/// @desc	Whether results are "set" or "add" to destination. 
/// @param	{Bool} _additive
function tite_set_cumulative(_additive=true) 
{
	tite_forceinline;
	TITE.cumulative = _additive;
}


/// @func	tite_sample(_name, _src);
/// @desc	Set datablock as texture sampler, input for operation.
/// @param	{String}			_name
/// @param	{Struct.TiteData}	_src
function tite_sample(_name, _src)
{
	var _shader = shader_current();
	var _sampler = shader_get_sampler_index(_shader, _name);
	gpu_set_tex_filter_ext(_sampler, _src.interpolate);
	gpu_set_tex_repeat_ext(_sampler, _src.repetive);
	texture_set_stage(_sampler, _src.Texture());
}
	
	
/// @func	tite_render();
/// @desc	Do the calculation, updates whole render target.
function tite_render()
{
	tite_forceinline;
	vertex_submit(TITE.vtxBufferFill, pr_trianglestrip, -1);
}
	
	
/// @func	tite_render_area(x0, y0, x1, y1);
/// @desc	Do the calculation, updates given area.
function tite_render_area(x0, y0, x1, y1)
{
	tite_forceinline;
	draw_sprite_stretched(tite_sprite_1x1, 0, x0, y0, x1-x0, y1-y0);
}


/// @func	tite_target(_src);
/// @desc	Set datablock as destination for calculations
/// @param	{Struct.TiteData}	_src
function tite_target(_src)
{
	tite_forceinline;
	surface_set_target(tite_data_surface(_src));
}


/// @func	tite_finish();
/// @desc	Computing to target is finished. As separate if other functionality is later added.
function tite_finish()
{
	tite_forceinline;
	surface_reset_target();
}


/// @func	tite_batch(_vtxArray, _vtxType, _tex, _bias);
/// @desc	Do the calculations by given vertex array.
/// @param	{Any} _vtxArray
/// @param	{Constant.PrimitiveType} _vtxType
/// @param	{Pointer.Texture} _tex
/// @param	{Array<Real>} _bias
function tite_batch(_vtxArray, _vtxType, _tex=undefined, _bias=[0, 0])
{
	tite_forceinline;
	_tex ??= -1;
	var _target = surface_get_target();
	var _targetW = surface_get_width(_target);
	var _targetH = surface_get_height(_target);
	var _maxW = TITE.vtxBatchMax[0];
	var _maxH = TITE.vtxBatchMax[1];
	tite_floatN("uniBatchBias", _bias);
	for(var i = 0; i < _targetW; i += min(_maxW, _targetW - i)) {
	for(var j = 0; j < _targetH; j += min(_maxH, _targetH - j)) {
		tite_floatN("uniBatchOffset", [i, j]);
		var _x = log2(min(_maxW, _targetW - i));
		var _y = log2(min(_maxH, _targetH - j));
		vertex_submit(_vtxArray[_x][_y], _vtxType, _tex);
	}}
}


/// @func	tite_batch_quad(_tex);
/// @desc	Do the calculations by given vertex quads.
/// @param	{Pointer.Texture} _tex
function tite_batch_quad(_tex=undefined)
{
	tite_forceinline;
	static bias = [0.0, 0.0];
	tite_batch(TITE.vtxBufferQuad, pr_trianglelist, _tex, bias);
}


/// @func	tite_batch_lines(_tex);
/// @desc	Do the calculations by given vertex lines.
/// @param	{Pointer.Texture} _tex
function tite_batch_lines(_tex=undefined)
{
	tite_forceinline;
	static bias = [0.5, 0.5];
	tite_batch(TITE.vtxBufferLine, pr_linelist, _tex, bias);
}


/// @func	tite_batch_points(_tex);
/// @desc	Do the calculations by given vertex points.
/// @param	{Pointer.Texture} _tex
function tite_batch_points(_tex=undefined)
{
	tite_forceinline;
	static bias = [0.5, 0.5];
	tite_batch(TITE.vtxBufferPoint, pr_pointlist, _tex, bias);
}


/*
/// @func	tite_batch_bias_quad();
/// @desc	Returns batch offset bias to accommodate machine differences.
function tite_batch_bias_quad()
{
	tite_forceinline;
	return [0, 0]; // Not necessary.
}


/// @func	tite_batch_bias_lines();
/// @desc	Returns batch offset bias to accommodate machine differences.
function tite_batch_bias_lines()
{
	tite_forceinline;
	
	// Preparations.
	var _w = 3;
	var _h = 3;
	var _x0 = floor(_w / 2); // Mid-point
	var _y0 = floor(_h / 2); //
	var _x1 = _x0 + 1; // To right.
	var _y1 = _y0 + 0; //
	vertex_format_begin();
	vertex_format_add_position();
	vertex_format_add_texcoord();
	vertex_format_add_color();
	var _format = vertex_format_end();
	var _vertex = vertex_create_buffer();
	var _buffer = buffer_create(_w * _h * 4, buffer_fixed, 1);
	var _surf = surface_create(_w, _h);
	var _tex = sprite_get_texture(tite_sprite_1x1, 0);
	
	// Create vertex buffer.
	vertex_begin(_vertex, _format);
	vertex_position(_vertex, _x0, _y0); 
	vertex_texcoord(_vertex, 0, 0); 
	vertex_color(_vertex, c_white, 1);
	vertex_position(_vertex, _x1, _y1); 
	vertex_texcoord(_vertex, 1, 1); 
	vertex_color(_vertex, c_white, 1);
	vertex_end(_vertex);
	
	// Draw at the middle-point.
	tite_begin();
	surface_set_target(_surf);
	draw_clear_alpha(0, 0);
	vertex_submit(_vertex, pr_linelist, _tex);
	surface_reset_target();
	tite_end();
	
	// Get bias offset.
	var _bias = [0, 0];
	buffer_get_surface(_buffer, _surf, 0);
	for(var j = 0; j < _h; j++) {
	for(var i = 0; i < _w; i++) {
		var _value = buffer_read(_buffer, buffer_u32);
		if (_value != 0)
		{
			_bias[0] = (_x0 - i);
			_bias[1] = (_y0 - j);
			break;
		}
	}}
	
	// Finalize.
	vertex_delete_buffer(_vertex);
	vertex_format_delete(_format);
	buffer_delete(_buffer);
	surface_free(_surf);
	return _bias;
}


/// @func	tite_batch_bias_points();
/// @desc	Returns batch offset bias to accommodate machine differences.
function tite_batch_bias_points()
{
	tite_forceinline;
	
	// Preparations.
	var _w = 3;
	var _h = 3;
	var _x0 = floor(_w / 2); // Mid-point
	var _y0 = floor(_h / 2); //
	vertex_format_begin();
	vertex_format_add_position();
	vertex_format_add_texcoord();
	vertex_format_add_color();
	var _format = vertex_format_end();
	var _vertex = vertex_create_buffer();
	var _buffer = buffer_create(_w * _h * 4, buffer_fixed, 1);
	var _surf = surface_create(_w, _h);
	var _tex = sprite_get_texture(tite_sprite_1x1, 0);
	
	// Create vertex buffer.
	vertex_begin(_vertex, _format);
	vertex_position(_vertex, _x0, _y0); 
	vertex_texcoord(_vertex, 0, 0); 
	vertex_color(_vertex, c_white, 1);
	vertex_end(_vertex);
	
	// Draw at the middle-point.
	tite_begin();
	surface_set_target(_surf);
	draw_clear_alpha(0, 0);
	vertex_submit(_vertex, pr_pointlist, _tex);
	surface_reset_target();
	tite_end();
	
	// Get offset.
	var _bias = [0, 0];
	buffer_get_surface(_buffer, _surf, 0);
	buffer_seek(_buffer, buffer_seek_start, 0);
	for(var j = 0; j < _h; j++) {
	for(var i = 0; i < _w; i++) {
		var _value = buffer_read(_buffer, buffer_u32);
		if (_value != 0)
		{
			_bias[0] = (_x0 - i);
			_bias[1] = (_y0 - j);
			break;
		}
	}}
	
	// Finalize.
	vertex_delete_buffer(_vertex);
	vertex_format_delete(_format);
	buffer_delete(_buffer);
	surface_free(_surf);
	return _bias;
}
*/







