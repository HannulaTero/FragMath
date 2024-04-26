// feather ignore GM2017


/// @func	tite_blend(_out, _BlendSettings);
/// @desc	Does given blend with all given arguments. 
/// @param	{Struct.TiteData} _out Set starting value beforehand.
/// @param	{Function} _BlendSettings Blend settings.
function tite_blend(_out, _BlendSettings)
{
	tite_begin();
	tite_target(_out);
	gpu_set_blendenable(true);
	_BlendSettings();
	for(var i = 2; i < argument_count; i++)
		tite_render_data(argument[i]);
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_add(_out);
/// @desc	Does addition with all given arguments. Uses only blend modes.
/// @param	{Struct.TiteData} _out Set starting value beforehand.
function tite_add(_out)
{
	tite_begin();
	tite_target(_out);
	gpu_set_blendenable(true);
	gpu_set_blendmode_ext(bm_one, bm_one);
	for(var i = 1; i < argument_count; i++)
		tite_render_data(argument[i]);
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_sub(_out);
/// @desc	Does subtraction with all given arguments. Uses only blend modes.
/// @param	{Struct.TiteData} _out Set starting value beforehand.
function tite_sub(_out)
{
	tite_begin();
	tite_target(_out);
	gpu_set_blendenable(true);
	gpu_set_blendequation(bm_eq_subtract);
	gpu_set_blendmode_ext(bm_one, bm_one);
	for(var i = 1; i < argument_count; i++)
		tite_render_data(argument[i]);
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_max(_out);
/// @desc	Gets maximum with all given arguments. Uses only blend modes.
/// @param	{Struct.TiteData} _out Set starting value beforehand (-infinity etc.)
function tite_max(_out)
{
	tite_begin();
	tite_target(_out);
	gpu_set_blendenable(true);
	gpu_set_blendequation(bm_eq_max);
	gpu_set_blendmode_ext(bm_one, bm_one);
	for(var i = 1; i < argument_count; i++)
		tite_render_data(argument[i]);
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_min(_out);
/// @desc	Gets minimum with all given arguments. Uses only blend modes.
/// @param	{Struct.TiteData} _out Set starting value beforehand (+infinity etc.)
function tite_min(_out)
{
	tite_begin();
	tite_target(_out);
	gpu_set_blendenable(true);
	gpu_set_blendequation(bm_eq_min);
	gpu_set_blendmode_ext(bm_one, bm_one);
	for(var i = 1; i < argument_count; i++)
		tite_render_data(argument[i]);
	tite_finish();
	tite_end();
	return _out;
}

