/// @desc CHANGE THE DATABLOCK SIZES
// feather ignore GM2017

var _previous = dimension;
if (keyboard_check_pressed(vk_up)) 
	dimension *= 2;

if (keyboard_check_pressed(vk_down)) 
	dimension /= 2;

dimension = clamp(dimension, 1, 2048);


// Update datablock sizes if dimension was changed.
if (_previous != dimension)
{
	var _params = {
		size: [dimensions, dimension]
	};
	matPos.Initialize(_params);
	matSpd.Initialize(_params);
	Reset();
}