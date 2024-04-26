// feather ignore GM2017

/// @func	tite_floatN(_name, _array);
/// @desc	Set shader uniforms with given name.
/// @param	{String}		_name
/// @param	{Array<Real>}	_array
function tite_floatN(_name, _array)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_f_array(_uniform, _array);
}


/// @func	tite_float1(_name, _x);
/// @desc	Set shader uniforms with given name.
/// @param	{String}	_name
/// @param	{Real}		_x
function tite_float1(_name, _x)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_f(_uniform, _x);
}


/// @func	tite_float2(_name, _x, _y);
/// @desc	Set shader uniforms with given name.
/// @param	{String}	_name
/// @param	{Real}		_x
/// @param	{Real}		_y
function tite_float2(_name, _x, _y)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_f(_uniform, _x, _y);
}


/// @func	tite_float3(_name, _x, _y, _z);
/// @desc	Set shader uniforms with given name.
/// @param	{String}	_name
/// @param	{Real}		_x
/// @param	{Real}		_y
/// @param	{Real}		_z
function tite_float3(_name, _x, _y, _z)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_f(_uniform, _x, _y, _z);
}


/// @func	tite_float4(_name, _x, _y, _z, W);
/// @desc	Set shader uniforms with given name.
/// @param	{String}	_name
/// @param	{Real}		_x
/// @param	{Real}		_y
/// @param	{Real}		_z
/// @param	{Real}		_w
function tite_float4(_name, _x, _y, _z, _w)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_f(_uniform, _x, _y, _z, _w);
}


/// @func	tite_float4_any(_name, _values);
/// @desc	Forces 4 items into uniform from given value.
/// @param	{String}	_name
/// @param	{Any}		_values		Single value or Array of values.
function tite_float4_any(_name, _values)
{
	tite_forceinline;
	static __array = [0.0, 0.0, 0.0, 0.0];
	if (is_array(_values)) 
	{
		var _count = max(4, array_length(_values));
		array_copy(__array, 0, _values, 0, _count);
		tite_floatN(_name, __array);
	} 
	else 
	{
		var _value = (_values ?? 0.0);
		tite_float4(_name, _value, _value, _value, _value);
	}
}


/// @func	tite_integer(_name, _x);
/// @desc	Set shader uniform with given name.
/// @param	{String}	_name
/// @param	{Real}		_x
function tite_integer(_name, _x)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_i(_uniform, _x);
}


/// @func	tite_integer1(_name, _x);
/// @desc	Set shader uniform with given name.
/// @param	{String}	_name
/// @param	{Real}		_x
function tite_integer1(_name, _x)
{
	tite_forceinline;
	tite_integer(_name, _x);
}


/// @func	tite_integer2(_name, _x, _y);
/// @desc	Set shader uniform with given name.
/// @param	{String}	_name
/// @param	{Real}		_x
/// @param	{Real}		_y
function tite_integer2(_name, _x, _y)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_i(_uniform, _x, _y);
}


/// @func	tite_integer3(_name, _x, _y, _z);
/// @desc	Set shader uniform with given name.
/// @param	{String}	_name
/// @param	{Real}		_x
/// @param	{Real}		_y
/// @param	{Real}		_z
function tite_integer3(_name, _x, _y, _z)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_i(_uniform, _x, _y, _z);
}


/// @func	tite_integer4(_name, _x, _y, _z, _w);
/// @desc	Set shader uniform with given name.
/// @param	{String}	_name
/// @param	{Real}		_x
/// @param	{Real}		_y
/// @param	{Real}		_z
/// @param	{Real}		_w
function tite_integer4(_name, _x, _y, _z, _w)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_i(_uniform, _x, _y, _z, _w);
}


/// @func	tite_integerN(_name, _array);
/// @desc	Set shader uniform with given name.
/// @param	{String}		_name
/// @param	{Array<Real>}	_array
function tite_integerN(_name, _array)
{
	tite_forceinline;
	var _shader = shader_current();
	var _uniform = shader_get_uniform(_shader, _name);
	shader_set_uniform_i_array(_uniform, _array);
}


