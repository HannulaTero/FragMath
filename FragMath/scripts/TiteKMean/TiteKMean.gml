
/// @func	TiteKMean(_params);
/// @desc	
/// @param	{Struct} _params
function TiteKMean(_params=undefined) constructor 
{
	/*
		Clusters is layed out as following:
		 - width stores dimensional values of cluster.
		 - height represents separate clusters.
		
		Indexes store datapoints' index for the nearest cluster.
		
		Input represent all datapoints and their dimensional values.
		 - Single dimension is rectangular "frame" in whole input.  
	*/
	
	// Create metadata.
	self.iteration = 0;
	self.layoutDatapoints = [1, 1];
	self.layoutDimensions = [1, 1];
	self.countDatapoints = 1;
	self.countDimensions = 1;
	self.countClusters = 1;
	self.format = surface_rgba8unorm;

	// Create datastructures.
	self.input = new TiteData(); 
	self.indexes = new TiteData();
	self.clusters = new TiteData();
	self.clustersSum = new TiteData();
	self.clustersCount = new TiteData();

	// Initialize values with parameters.
	if (_params != undefined)
	{
		tite_kmean_initialize(self, _params); 
	}

	
	/// @func	Initialize(_params);
	/// @desc	
	/// @param	{Struct} _params
	static Initialize = function(_params={})
	{
		return tite_kmean_initialize(self, _params);
	};


	/// @func	Set(_src, _dimension);
	/// @desc	Set datapoints' values for specific dimension.
	/// @param	{Struct.TiteData} _src
	/// @param	{Real} _dimension
	static Set = function(_src, _dimension, _offset=0)
	{
		return tite_kmean_set(self, _src, _dimension, _offset);
	};
	
	
	/// @func	Begin(_ppUse, _ppProbability);
	/// @desc	Find initial cluster seeds.
	/// @param	{Bool} _ppUse			Whether use "K-Mean++" -method.
	/// @param	{Real} _ppProbability	K-Mean++ parameter.
	static Begin = function(_ppUse=false, _ppProbability=undefineed)
	{
		if (_ppUse)
			return tite_kmean_begin_plusplus(self, _ppProbability);
		else
			return tite_kmean_begin_regular(self);
	};
	
	
	/// @func	Indexify();
	/// @desc	Generates cluster-indexes for datapoints.
	static Indexify = function()
	{
		return tite_kmean_indexify(self);
	};
	
	
	/// @func	Update();
	/// @desc	Update clusters with their closest datapoints.
	static Update = function()
	{
		return tite_kmean_update(self);
	};
	
	
	/// @func	Free();
	/// @desc	
	static Free = function()
	{
		return tite_kmean_free(self);
	};
}



