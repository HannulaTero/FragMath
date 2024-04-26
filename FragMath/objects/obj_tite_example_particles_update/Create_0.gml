/// @desc
// feather ignore GM2017

// Allow resizing for more.
dimension = 256;
		
// The gpu datablacks, used for simple particles.
matPos = new TiteData(dimension, dimension, { name: "Position" });
matSpd = new TiteData(dimension, dimension, { name: "Speed" });
lutSin = new TiteDataLut({
	width: 256,
	rangeMin: -pi,
	rangeMax: +pi,
	func: function(_lhs) { return sin(_lhs); },
	name: "LUT sin(x)"
});

vm = new TiteVM({
	pos : undefined,
	spd : undefined,
	dimension: dimension
});

vm.Execute(@"
	pos = data(dimension, dimension);
	spd = data(dimension, dimension);
");


// Helper methods.
Reset = function() 
{
	var _len = 64.0;
	var _min = room_width * 0.5 - _len;
	var _max = room_width * 0.5 + _len;
	matPos.Randomize(_min, _max);
	matSpd.Randomize(-16.0, +16.0);	// Random direction.
	matSpd.Offset(,[0.0, -12.0]);	// Upward momentum.
};



