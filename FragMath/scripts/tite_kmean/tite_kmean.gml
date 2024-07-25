// feather ignore GM2017





/// @func	tite_kmean(_params);
/// @desc	
/// @param	{Struct} _params
function tite_kmean(_params=undefined)
{ 
	return new TiteKMean(_params);
}


/// @func	tite_kmean_set(_kmean, _src, _dimension, _offset);
/// @desc	Set datapoints' values for specific dimension.
/// @param	{Struct.TiteKmean} _kmean
/// @param	{Struct.TiteData} _src
/// @param	{Real} _dimension	Which dimension.
function tite_kmean_set(_kmean, _src, _dimension=0, _offset=0)
{ 
	tite_timer_begin("K-Mean Set Dimension");
	tite_begin();
	tite_target(_kmean.input); 
	draw_surface_stretched(
		_src.Surface(), 
		_kmean.layoutDatapoints[0] * _kmean.layoutDimensions[0],
		_kmean.layoutDatapoints[1] * _kmean.layoutDimensions[1],
		_kmean.layoutDatapoints[0],
		_kmean.layoutDatapoints[1]
	);
	tite_finish();
	tite_end();
	tite_timer_end();
	return _kmean;
}


/// @func	tite_kmean_begin_regular(_kmean);
/// @desc	Initializes cluster values with random value samples from data.
/// @param	{Struct.TiteKMean} _kmean
function tite_kmean_begin_regular(_kmean)
{
	tite_timer_begin("K-Mean Begin");
	
	// feather ignore GM1041
	// Preparations.
	_kmean.iteration = 0;
	var _data = _kmean.input;
	var _dataW = _kmean.dataSize[0];
	var _dataH = _kmean.dataSize[1];
	var _clusters = _kmean.clusters;
	var _countClusters = _kmean.countClusters;
	var _countDimensions = _kmean.countDimensions;
	var _position = new TiteData({ 
		size: [1, _countClusters], format: surface_rgba32float 
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
	return _kmean;
}


/// @func	tite_kmean_begin_plusplus(_kmean);
/// @desc	Smarter (but demanding) initialization of cluster values.
/// @param	{Struct.TiteKMean} _kmean
/// @param	{Real}	_probability Selection probability when finding datapoint.
function tite_kmean_begin_plusplus(_kmean, _probability=0.8)
{
	/* 
		K-Mean++ initialization tries to find as different 
		starting values for clusters as possible.
	*/
	tite_timer_begin("K-Mean++ Initialization full");
	tite_timer_begin("K-Mean++ Preparations");
	
	// Preparations.
	_kmean.iteration = 0;
	var _data = _kmean.input;
	var _dataW = _kmean.dataSize[0];
	var _dataH = _kmean.dataSize[1];
	var _clusters = _kmean.clusters;
	var _countClusters = _kmean.countClusters;
	var _countDimensions = _kmean.countDimensions;
	var _texRandom = tite_texture_random();
	
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


/// @func	tite_kmean_indexify(_kmean);
/// @desc	Generates indexes for data based on nearest cluster centroids.
/// @param	{Struct.TiteKMean} _kmean
function tite_kmean_indexify(_kmean)
{
	tite_timer_begin("K-Mean Indexify");
	
	// Preparations.
	_kmean.iteration++;
	var _data = _kmean.input;
	var _dataW = _kmean.dataSize[0];
	var _dataH = _kmean.dataSize[1];
	var _clusters = _kmean.clusters;
	var _countClusters = _kmean.countClusters;
	var _countDimensions = _kmean.countDimensions;
	var _texRandom = tite_texture_random();
	
	// Create helper data.
	var _params = { 
		size : [_dataW, _dataH],
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


/// @func	tite_kmean_update(_kmean);
/// @desc	Updates clusters based on current indexes for data.
/// @param	{Struct.TiteKMean} _kmean
function tite_kmean_update(_kmean)
{
	tite_timer_begin("K-Mean Indexify");
	
	
	
	tite_timer_end();
}


/// @func	tite_kmean_free(_kmean);
/// @desc	
/// @param	{Struct.TiteKMean} _kmean
function tite_kmean_free(_kmean)
{
	tite_timer_begin("K-Mean Free");
	// Clear metadata.
	_kmean.iteration = 0;
	_kmean.countDatapoints = 1;
	_kmean.countDimensions = 1;
	_kmean.countClusters = 1;
	
	// Clear datastructures.
	_kmean.input.Free();
	_kmean.indexes.Free();
	_kmean.clusters.Free();
	_kmean.clustersSum.Free();
	_kmean.clustersCount.Free();
	tite_timer_end();
	return;
}
	
	
	
	
	
	
	




