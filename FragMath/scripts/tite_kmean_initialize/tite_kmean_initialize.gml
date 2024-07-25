

/// @func	tite_kmean_initialize(_kmean, _params);
/// @desc	
/// @param	{Struct.TiteKmean} _kmean
/// @param	{Struct} _params
function tite_kmean_initialize(_kmean, _params=undefined)
{ 
	tite_timer_begin("K-Mean Initialize");
	
	// Get the parameters.
	var _datapoints = _params[$ "datapoints"];	// Real or Array
	var _dimensions = _params[$ "dimensions"];	// Real or Array
	var _clusters = _params[$ "clusters"];		// Real
	var _format = _params[$ "format"];			// Type-constant or String.
		_format = tite_format_get(_format);
		
	// Sanity checks.
	if (_datapoints == undefined)	
	&& (_dimensions == undefined)
		tite_warning("K-Mean, neither datapoint or dimension count was defined.");
	_datapoints ??= 1;
	_dimensions ??= 1;
	
	// Datapoints' layout in 2D, a "frame" size within input.
	var _layoutDatapoints = tite_resize_power2(_datapoints);
	var _countDatapoints = is_array(_datapoints) 
		? _layoutDatapoints[0] * _layoutDatapoints[1]
		: _datapoints;
		
	// Dimensions layout in 2D, how "frames" are layed out within input.
	var _layoutDimensions = tite_resize_power2(_dimensions);
	var _countDimensions = is_array(_dimensions)
		? _layoutDimensions[0] * _layoutDimensions[1]
		: _dimensions;

	// Get input size from datapoints.
	var _sizeInput = [
		_layoutDatapoints[0] * _layoutDimensions[0],
		_layoutDatapoints[1] * _layoutDimensions[1]
	];
	
	// Get cluster size.
	var _countClusters = _clusters ?? 1;
	var _sizeClusters = [
		_countDimensions, 
		_countClusters
	];
	
	// Set the metadata.
	_kmean.iteration = 0;
	_kmean.layoutDatapoints = _layoutDatapoints;
	_kmean.layoutDimensions = _layoutDimensions;
	_kmean.countDatapoints = _countDatapoints;
	_kmean.countDimensions = _countDimensions;
	_kmean.countClusters = _countClusters;
	
	// Initialize datastructures.
	_kmean.input.Initialize({
		name: "K-Mean Input",
		format: _kmean.format,
		size: _sizeInput
	});
	
	_kmean.indexes.Initialize({
		name: "K-Mean Indexes",
		format: "r32float",
		size: _layoutDatapoints
	});
	
	_kmean.clusters.Initialize({
		name: "K-Mean Clusters",
		format: _kmean.format,
		size: _sizeClusters
	});
	
	_kmean.clusters.Initialize({
		name: "K-Mean Clusters Sum",
		format: "rgba32float",
		size: _sizeClusters
	});
	
	_kmean.clusters.Initialize({
		name: "K-Mean Clusters Count",
		format: "r32float",
		size: [1, _countClusters]
	});
	
	
	tite_timer_end();
	return _kmean;
}
