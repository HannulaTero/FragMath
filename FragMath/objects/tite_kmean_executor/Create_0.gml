/// @desc


self.callback = function() { };
self.data = [];
self.clusters = undefined;
self.dimensions = 1;
self.maxClusters = 255;


Initialize = function(_maxClusters, _data)
{
	self.data = is_array(_data) ? _data : [_data];
	self.dimensions = array_length(self.data);
	self.maxClusters = _maxClusters;
	self.clusters = new TiteData(self.dimensions, self.maxClusters);
};




