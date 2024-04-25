
/// @func	TiteKMean(_maxClusters, _format);
/// @desc	
/// @param	{Real} _maxClusters
/// @param	{Constant.SurfaceFormatType} _format
function TiteKMean(_maxClusters=255, _format=surface_rgba32float) constructor
{
	/*
		Clusters width represents dimenionality.
		Clusters height represents separate clusters.
		Data array represents different dimensionalities of data.
	*/
	self.data = [];
	self.maxClusters = _maxClusters;
	self.format = _format;
	self.clusters = new TiteData(1, self.maxClusters, { format: self.format});
	self.iteration = 0;
	
	
	/// @func	AddDimension(_dimension);
	/// @desc
	/// @param	{Struct.TiteData}	_dimension
	static AddDimension = function(_dimension)
	{
		array_push(self.data, _dimension);
		var _count = array_length(self.data);
		self.clusters.Resize(_count, self.maxClusters);
		return self;
	};
	
	
	/// @func	Initialize();
	/// @desc	
	static Initialize = function()
	{
		tite_kmean_initialize(self);
		return self;
	};
	
	
	/// @func	InitializePlusPlus();
	/// @desc	
	static InitializePlusPlus = function()
	{
		self.iteration = 0;
		return self;
	};
	
	
	/// @func	Free();
	/// @desc	
	static Free = function()
	{
		self.clusters.Free();
		return self;
	};
}




/// @func	tite_kmean(_out, _maxClusters, _sources);
/// @desc	Generates clusters from given dimensional data.
/// @param	{Struct.TiteData} _out				Stores generated clusters.
/// @param	{Real} _maxClusters					Maximum amount of clusters.
/// @param	{Array<Struct.TiteData>} _sources	Array of source data, each representing additional dimensionality.
function tite_kmean(_out, _maxClusters, _sources)
{ 

	return _out;
}


/// @func	tite_kmean_initialize(_kmean);
/// @desc	Initializes cluster values with random value samples from data.
/// @param	{Struct.TiteKMean} _kmean
function tite_kmean_initialize(_kmean)
{
	// Preparations.
	_kmean.iteration = 0;
	var _clusters = _kmean.clusters;
	var _w = _clusters.size[0];
	var _h = _clusters.size[1];
	var _position = new TiteData(1, _h, { format: surface_rgba32float });
	
	// Select random position for each cluster.
	// These are used to sample starting values (same for each dimension).
	tite_randomize(_position, 0, 1);
	tite_begin();
	tite_shader(tite_op_kmean_select);
	for(var i = 0; i < _w; i++)
	{
		tite_sample("texPos", _position);
		tite_sample("texDim", _kmean.data[i]);
		tite_floatN("uniTexelPos", _position.texel);
		tite_target(_clusters);
		tite_render_area(i, 0, i+1, _h);
		tite_finish();
	}
	tite_end();
	tite_data_free(_position);
	return self;
}


/// @func	tite_kmean_initialize_plusplus(_kmean);
/// @desc	Smarter but demanding initialization of cluster values.
/// @param	{Struct.TiteKMean} _kmean
function tite_kmean_initialize_plusplus(_kmean)
{
	// This tries to as different values as possible.
	
}









