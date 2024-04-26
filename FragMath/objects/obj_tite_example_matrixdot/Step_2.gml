/// @desc COMPARE RESULTS.
// feather ignore GM2017

if (keyboard_check_pressed(vk_enter))
{
	var _bytes = buffer_get_size(outCpu);
	buffer_seek(outCpu, buffer_seek_start, 0);
	buffer_seek(result, buffer_seek_start, 0);
	repeat(_bytes / dsize)
	{
		var _a = buffer_read(outCpu, dtype);
		var _b = buffer_read(result, dtype);
		if (abs(_a - _b) > 0.01)
		{
			show_debug_message($"Not correct! Difference: {abs(_a - _b)}");
			break;
		}
	}
}




