// feather ignore GM2017

/// @func	TiteKMean_Frames(_countClusters, _format);
/// @desc	
/// @param	{Real} _countClusters
/// @param	{Any} _format			Surface format constant or string.
function TiteKMean_Frames(_countClusters=256, _format=surface_rgba32float) constructor
{
	/*
		Clusters width represents dimensionality.
		Clusters height represents separate clusters.
		Data array represents different dimensionalities of data.
		-> Data sizes might not actually match.
		-> Assume interpolation in those cases. 
		-> Separate maximum size values are stored to easy of use.
		Indexes tell how data is indexed to closest cluster.
	*/
	self.data = []; 
	self.dataSize = [1, 1];
	self.countClusters = _countClusters;
	self.countDimensions = 0;
	self.clusters = new TiteData({
		size: [1, self.countClusters], 
			format: _format 
	});
	self.indexes = new TiteData({
		size: [1, 1], 
		format : "r32float" 
	});
	self.iteration = 0;
	
	
	/// @func	AddDimension(_dimension);
	/// @desc
	/// @param	{Struct.TiteData}	_dimension
	static AddDimension = function(_dimension)
	{
		array_push(self.data, _dimension);
		self.dataSize[0] = max(self.dataSize[0], _dimension.size[0]);
		self.dataSize[1] = max(self.dataSize[1], _dimension.size[1]);
		self.countDimensions = array_length(self.data);
		self.clusters.Resize([
			self.countDimensions, 
			self.countClusters
		]);
		self.indexes.Resize(dataSize);
		return self;
	};
	
	
	/// @func	Initialize();
	/// @desc	
	static Initialize = function()
	{
		tite_kmean_frames_initialize(self);
		return self;
	};
	
	
	/// @func	InitializePlusPlus(_probability);
	/// @desc	
	/// @param	{Real} _probability
	static InitializePlusPlus = function(_probability=undefined)
	{
		tite_kmean_frames_initialize_plusplus(self, _probability);
		return self;
	};
	
	
	/// @func	Indexify();
	/// @desc	Generates indexes for data.
	static Indexify = function()
	{
		tite_kmean_frames_indexify(self);
		return self;
	};
	
	
	/// @func	Update();
	/// @desc	Updates clusters based on indexes for data.
	static Update = function()
	{
		tite_kmean_frames_indexify(self);
		return self;
	};
	
	
	/// @func	Free();
	/// @desc	
	static Free = function()
	{
		self.clusters.Free();
		self.indexes.Free();
		return self;
	};
}


/// @func	tite_kmean_frames(_out, _maxClusters, _sources);
/// @desc	Generates clusters from given dimensional data.
/// @param	{Struct.TiteData} _out				Stores generated clusters.
/// @param	{Real} _maxClusters					Maximum amount of clusters.
/// @param	{Array<Struct.TiteData>} _sources	Array of source data, each representing additional dimensionality.
function tite_kmean_frames(_out, _maxClusters, _sources)
{ 

	return _out;
}


/// @func	tite_kmean_frames_initialize(_kmean);
/// @desc	Initializes cluster values with random value samples from data.
/// @param	{Struct.TiteKMean} _kmean
function tite_kmean_frames_initialize(_kmean)
{
	tite_timer_begin("K-Mean Initialize");
	
	// feather ignore GM1041
	// Preparations.
	_kmean.iteration = 0;
	var _data = _kmean.data;
	var _dataW = _kmean.dataSize[0];
	var _dataH = _kmean.dataSize[1];
	var _clusters = _kmean.clusters;
	var _countClusters = _kmean.countClusters;
	var _countDimensions = _kmean.countDimensions;
	var _position = new TiteData({
		size: [1, _countClusters], 
		format: "rgba32float" 
	});
	
	// Select random position for each cluster.
	// These are used to sample starting values (same for each dimension).
	tite_randomize_tex(_position);
	tite_begin();
	tite_shader(tite_op_kmean_initialize_select);
	tite_sample("texPos", _position);
	tite_floatN("uniTexelPos", _position.texel);
	tite_target(_clusters); 
	for(var i = 0; i < _countDimensions; i++)
	{
		tite_sample("texDim", _data[i]);
		tite_render_area(i, 0, i+1, _countClusters);
	}
	tite_finish();
	tite_end();
	tite_data_free(_position);
	
	tite_timer_end();
	return self;
}


/// @func	tite_kmean_frames_initialize_plusplus(_kmean);
/// @desc	Smarter but demanding initialization of cluster values.
/// @param	{Struct.TiteKMean} _kmean
/// @param	{Real}	_probability Selection probability when finding datapoint.
function tite_kmean_frames_initialize_plusplus(_kmean, _probability=0.8)
{
	/* 
		K-Mean++ initialization tries to find as different 
		starting values for clusters as possible.
	*/
	tite_timer_begin("K-Mean++ Initialization full");
	tite_timer_begin("K-Mean++ Preparations");
	
	// Preparations.
	_kmean.iteration = 0;
	var _data = _kmean.data;
	var _dataW = _kmean.dataSize[0];
	var _dataH = _kmean.dataSize[1];
	var _clusters = _kmean.clusters;
	var _countClusters = _kmean.countClusters;
	var _countDimensions = _kmean.countDimensions;
	var _texRandom = tite_texture_random();
	
	
	// Work with GML buffers, as can't utilize parallelism as well.
	// tite_timer_begin("K-Mean++ Get GPU data to GML");
	// var _buffClusters = _clusters.ToBuffer();
	// var _buffData = array_create(_countDimensions);
	// for(var i = 0; i < _countDimensions; i++)
	// {
	// 	_buffData[i] = _data[i].ToBuffer();
	// }
	// tite_timer_end();
	// tite_timer_begin("K-Mean++ Get GML data to GPU.");
	// _clusters.FromBuffer(_buffClusters);
	// for(var i = 0; i < _countDimensions; i++)
	// {
	// 	_data[i].FromBuffer(_buffData[i]);
	// }
	// tite_timer_end();
	
	
	// Create helper data structures.
	var _distMax = new TiteData({ 
		size: [1, 1],
		format : "r32float" 
	});
	
	var _distPrev = new TiteData({ 
		size: [_dataW, _dataH],
		format : "r32float" 
	});
	
	var _distNext = new TiteData({ 
		size: [_dataW, _dataH],
		format : "r32float" 
	});
	
	var _position = new TiteData({ 
		size: [1, 1],
		format : "rgba32float" 
	});
	
	var _distTemp = _distPrev;
	tite_timer_end();
	
	// Select first cluster value at random.
	tite_timer_begin("K-Mean++ First cluster");
	tite_randomize_tex(_position);
	tite_begin();
	tite_shader(tite_op_kmean_initialize_select);
	tite_sample("texPos", _position);
	tite_floatN("uniTexelPos", _position.texel);
	tite_target(_clusters); 
	for(var i = 0; i < _countDimensions; i++)
	{
		tite_sample("texDim", _data[i]);
		tite_render_area(i, 0, i+1, 1);
	}
	tite_finish();
	tite_end();
	tite_timer_end();
	
	tite_set(_distPrev, tite_float_max);
	for(var i = 1; i < _countClusters; i++)
	{
		// Get the distances to the nearest cluster, then find the single maximum distance.
		// - Currently this is most expensive part of K-Mean++.
		tite_timer_begin($"K-Mean++ Cluster {i}");
		for(var j = 0; j < i; j++)
		{
			tite_begin();
			tite_target(_distNext);
			draw_clear_alpha(0, 0);
			gpu_set_blendenable(true);
			gpu_set_blendequation(bm_eq_add);
			gpu_set_blendmode_ext(bm_one, bm_one);
			tite_shader(tite_op_kmean_plusplus_sqrdiff);
			tite_sample("texClusters", _clusters);
			tite_floatN("uniTexelClusters", _clusters.texel);
			for(var k = 0; k < _countDimensions; k++)
			{
				tite_sample("texDim", _data[k]);
				tite_floatN("uniTexelDim", _data[k].texel);
				tite_float2("uniClusterIndex", k, j);
				tite_render();
			}
			tite_finish();
			tite_end();
			tite_min(_distNext, _distPrev);
			_distTemp = _distNext;
			_distNext = _distPrev;
			_distPrev = _distTemp;
		}
		tite_reduce_max(_distMax, _distTemp);
		_distMax.Sqrt();
		
		// Sample from image based on probability.
		var _seedX = (get_timer() mod 2777.1097) / 2777.1097;
		var _seedY = (get_timer() mod 1097.2777) / 1097.2777;
		tite_begin();
		tite_target(_position);
		tite_shader(tite_op_kmean_plusplus_probability);
		tite_sample("texDist", _distTemp);
		tite_sample("texDistMax", _distMax);
		tite_sample("texRandom", _texRandom);
		tite_floatN("uniTexelDist", _distTemp.texel);
		tite_floatN("uniTexelRandom", _texRandom.texel);
		tite_floatN("uniSizeDist", _distTemp.size);
		tite_float2("uniSeed", _seedX, _seedY);
		tite_float1("uniProbability", _probability);
		tite_render();
		tite_finish();
		tite_end();
		
		// Update cluster value.
		tite_begin();
		tite_target(_clusters);
		tite_shader(tite_op_kmean_plusplus_select);
		tite_sample("texPos", _position);
		for(var k = 0; k < _countDimensions; k++)
		{
			tite_sample("texDim", _data[k]);
			tite_floatN("uniTexelDim", _data[k].texel);
			tite_render_area(k, i, k+1, i+1);
		}
		tite_finish();
		tite_end();
		tite_timer_end();
	} 
	
	
	// Finalize, free temporal datas.
	tite_data_free(_position);
	tite_data_free(_distPrev);
	tite_data_free(_distNext);
	tite_data_free(_distMax);
	tite_timer_end();
	return _kmean;
}


/// @func	tite_kmean_frames_indexify(_kmean);
/// @desc	Generates indexes for data based on nearest cluster centroids.
/// @param	{Struct.TiteKMean} _kmean
function tite_kmean_frames_indexify(_kmean)
{
	tite_timer_begin("K-Mean Indexify");
	
	// Preparations.
	_kmean.iteration++;
	var _data = _kmean.data;
	var _dataW = _kmean.dataSize[0];
	var _dataH = _kmean.dataSize[1];
	var _clusters = _kmean.clusters;
	var _countClusters = _kmean.countClusters;
	var _countDimensions = _kmean.countDimensions;
	var _texRandom = tite_texture_random();
	
	// Create helper data.
	var _params = { 
		size: [_dataW, _dataH],
		format : "r32float" 
	};
	
	var _distPrev = new TiteData(_params);
	var _distCurr = new TiteData(_params);
	var _distNext = new TiteData(_params);
	var _distTemp = _distPrev;
	
	var _indexPrev = new TiteData(_params);
	var _indexNext = new TiteData(_params);
	var _indexTemp = _indexPrev;
	
	// Find closest cluster index for each datapoint.
	tite_set(_indexPrev, -1);
	tite_set(_distPrev, tite_float_max);
	for(var i = 0; i < _countClusters; i++)
	{
		// Find distances to selected cluster.
		tite_begin();
		tite_target(_distCurr);
		draw_clear_alpha(0, 0);
		gpu_set_blendenable(true);
		gpu_set_blendequation(bm_eq_add);
		gpu_set_blendmode_ext(bm_one, bm_one);
		tite_shader(tite_op_kmean_indexify_sqrdiff);
		tite_sample("texClusters", _kmean.clusters);
		tite_floatN("uniTexelClusters", _kmean.clusters.texel);
		for(var j = 0; j < _countDimensions; j++)
		{
			tite_sample("texDim", _data[j]);
			tite_floatN("uniTexelDim", _data[j].texel);
			tite_float2("uniClusterIndex", j, i);
			tite_render();
		}
		tite_finish();
		tite_end();
		
		// Make choose whether update current index.
		tite_begin();
		tite_target_ext(0, _indexNext);
		tite_target_ext(1, _distNext);
		tite_shader(tite_op_kmean_indexify_select);
		tite_sample("texDistPrev", _distPrev);
		tite_sample("texDistCurr", _distCurr);
		tite_sample("texIndexPrev", _indexPrev);
		tite_floatN("uniTexel", _kmean.indexes.texel);
		tite_float1("uniIndexCurr", i);
		tite_render();
		tite_finish();
		tite_end();
		
		//var _buff = _kmean.indexes.ToBuffer();
		//_distPrev.ToBuffer(_buff);
		//_indexPrev.ToBuffer(_buff);
		//_distNext.ToBuffer(_buff);
		//_indexNext.ToBuffer(_buff);
		//buffer_delete(_buff);
		//
		// Swap around.
		_distTemp = _distNext;
		_distNext = _distPrev;
		_distPrev = _distTemp;
		_indexTemp = _indexNext;
		_indexNext = _indexPrev;
		_indexPrev = _indexTemp;
	}
	
	// Finalization.
	tite_copy(_kmean.indexes, _indexTemp);
	tite_data_free(_indexPrev);
	tite_data_free(_indexNext);
	tite_data_free(_distPrev);
	tite_data_free(_distCurr);
	tite_data_free(_distNext);
	tite_timer_end();
	return _kmean;
}


/// @func	tite_kmean_frames_update(_kmean);
/// @desc	Updates clusters based on current indexes for data.
/// @param	{Struct.TiteKMean} _kmean
function tite_kmean_frames_update(_kmean)
{
	tite_timer_begin("K-Mean Indexify");
	
	
	
	tite_timer_end();
}
	
	
	
	
	
	
	
	




