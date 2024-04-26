/// @desc GPU CALCULATIONS.
// feather ignore GM2017


if (keyboard_check_pressed(vk_enter))
{
	var _dim = new TiteData(1024, 1024, { format : "rgba32float "});
	tite_randomize_tex(_dim);
	kmean.AddDimension(_dim);
}


if (keyboard_check_pressed(vk_backspace))
{
	var _spr = spr_tite_example_kmean;
	var _count = sprite_get_number(_spr);
	for(var i = 0; i < _count; i++)
	{
		var _dim = new TiteData(1024, 1024, { format : "rgba32float "});
			_dim.FromSprite(_spr, i);
		kmean.AddDimension(_dim);
	}
}


if (keyboard_check_pressed(ord("1")))
{
	kmean.Initialize();
}


if (keyboard_check_pressed(ord("2")))
{
	kmean.InitializePlusPlus();
}


if (keyboard_check_pressed(ord("3")))
{
	kmean.Indexify();
}



