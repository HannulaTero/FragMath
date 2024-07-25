// feather ignore GM2017

/// @func	tite_randomize(_out, _min, _max, _seedX, _seedY);
/// @desc	Randomizes the target. Does randomization calculation in shader!
/// @param	{Struct.TiteData} _out
/// @param	{Any} _min
/// @param	{Any} _max
/// @param	{Any} _seedX
/// @param	{Any} _seedY
function tite_randomize(_out, _min=undefined, _max=undefined, _seedX=undefined, _seedY=undefined)
{ 
	_seedX ??= (get_timer() mod 2777.1097) / 2777.1097;
	_seedY ??= (get_timer() mod 1097.2777) / 1097.2777;
	tite_begin();
	tite_shader(tite_op_randomize);
	tite_floatN("uniTexelA", _out.texel);
	tite_float4_any("uniMin", _min ?? 0);
	tite_float4_any("uniMax", _max ?? 1);
	tite_float4_any("uniSeedX", _seedX);
	tite_float4_any("uniSeedY", _seedY);
	tite_float4("uniFactor", 2.12, 2.34, 2.56, 2.78);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_randomize_tex(_out, _min, _max, _seedX, _seedY);
/// @desc	Randomizes the target. Uses premade texture for randomization.
/// @param	{Struct.TiteData} _out
/// @param	{Any} _min
/// @param	{Any} _max
/// @param	{Any} _seedX
/// @param	{Any} _seedY
function tite_randomize_tex(_out, _min=undefined, _max=undefined, _seedX=undefined, _seedY=undefined)
{ 
	_seedX ??= (get_timer() mod 2777.1097) / 2777.1097;
	_seedY ??= (get_timer() mod 1097.2777) / 1097.2777;
	var _texRandom = tite_texture_random();
	tite_begin();
	tite_shader(tite_op_randomize_tex);
	tite_sample("texRandom", _texRandom);
	tite_floatN("uniTexelRandom", _texRandom.texel);
	tite_float2("uniSeed", _seedX, _seedY);
	tite_float4_any("uniMin", _min ?? 0);
	tite_float4_any("uniMax", _max ?? 1);
	tite_target(_out);
	tite_render();
	tite_finish();
	tite_end();
	return _out;
}


/// @func	tite_texture_random(_recreate);
/// @desc	Returns premade randomization texture. 
/// @param	{Bool} _recreate Whether randomization is recreated.
function tite_texture_random(_recreate=false)
{
	// Constants.
	static initialized = false;
	static dtype = buffer_f32;
	static dsize = buffer_sizeof(dtype);
	static bytes = count * dsize * 4;
	static buffer = buffer_create(bytes, buffer_fixed, 1);
	static texture = new TiteData({ 
		size: [256, 256],
		format: "rgba32float" 
	});
	
	// Create random pattern in buffer. 
	if (initialized == false) || (_recreate == true)
	{
		texture.Free();
		buffer_seek(buffer, buffer_seek_start, 0);
		repeat(texture.count)
		{
			buffer_write(buffer, dtype, random(1));
			buffer_write(buffer, dtype, random(1));
			buffer_write(buffer, dtype, random(1));
			buffer_write(buffer, dtype, random(1));
		}
		buffer_seek(buffer, buffer_seek_start, 0);
		initialized = true;
	}
	
	// Return random texture, make sure volatile gpu data exists.
	if (!texture.Exists())
		texture.FromBuffer(buffer);
	return texture;
}
