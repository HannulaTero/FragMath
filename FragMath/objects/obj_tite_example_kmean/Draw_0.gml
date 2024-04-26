/// @desc GPU CALCULATIONS.
// feather ignore GM2017


if (keyboard_check_pressed(vk_enter))
{
	var _dim = new TiteData(1024, 1024, { format : "rgba32float "});
	tite_randomize_tex(_dim);
	kmean.AddDimension(_dim);
}


if (keyboard_check_pressed(ord("1")))
{
	kmean.Initialize();
}


if (keyboard_check_pressed(ord("2")))
{
	kmean.InitializePlusPlus();
}