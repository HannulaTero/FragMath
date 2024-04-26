/// @desc VISUALIZE.
// feather ignore GM2017

var _x = room_width - 64;
var _y = 64;
	_x += lengthdir_x(current_time, 16);
	_y += lengthdir_y(current_time, 16);
draw_circle(_x, _y, 12, true);


// Draw surfaces.
var _scale = 0.5;
var _x0 = 16;
var _y0 = 16;
var _x1 = _x0 + lhsGpu.size[0] * _scale + 16;
var _y1 = _y0;
var _x2 = _x0;
var _y2 = _y0 + lhsGpu.size[1] * _scale + 16;

var _size = 128;
var _params = {
	xscale: _scale,
	yscale: _scale,
	normalize: true,
	rangeMin: -2.5,
	rangeMax: +2.05,
	background: true,
	outline: true
};

lhsGpu.Draw(_x0, _y0, _params);
rhsGpu.Draw(_x1, _y1, _params);
outGpu.Draw(_x2, _y2, {
	xscale: _scale,
	yscale: _scale,
	normalize: true,
	rangeMin: -32.0,
	rangeMax: +32.0,
	background: true,
	outline: true
});



