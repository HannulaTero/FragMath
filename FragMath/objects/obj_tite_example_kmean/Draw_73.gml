/// @desc VISUALIZE.
// feather ignore GM2017


kmean.clusters.Draw(16, 16, {
	width: 256, 
	height: 256,
	outline: true,
	background: true
});

kmean.indexes.Draw(288, 16, {
	width: 256, 
	height: 256,
	outline: true,
	background: true,
	normalize: true,
	rangeMin: 0.0,
	rangeMax: 255.0,
});

var _count = array_length(kmean.data);
for(var i = 0; i < _count; i++)
{
	var _x = 16 + i * 80;
	var _y = 288;
	kmean.data[i].Draw(_x, _y, {
		width: 64, 
		height: 64,
		outline: true,
		background: true
	});
}