// @feather ignore GM2017


function tite_sort_init(_sorter, _source, _count=tite_float_max) 
{
	tite_begin();
	tite_shader(tite_op_sort_init);
	tite_sample("texA", _source);
	tite_floatN("uniTexelA", _source.texel);
	tite_floatN("uniSizeA", _source.size);
	tite_float1("uniCount", _count);
	tite_float1("uniNonSort", tite_float_max);
	tite_target(_sorter);
	tite_render();
	tite_finish();
	tite_end();
}


function tite_sort_move(_target, _sorter, _source=undefined) 
{
	// If no explicit source, then target is source.
	var _temporal = false;
	if (is_undefined(_source)) 
	{
		_temporal = true;
		_source = _target.Clone(true);
	}
	
	tite_begin();
	tite_shader(tite_op_sort_move);
	tite_sample("texA", _sorter);
	tite_sample("texB", _source);
	tite_floatN("uniTexelA", _sorter.texel);
	tite_floatN("uniTexelB", _source.texel);
	tite_target(_target);
	tite_render();
	tite_finish();
	tite_end();	
	
	if (_temporal)
	{
		tite_data_free(_source);
	}
}


function tite_oddeven_sort(_sorter, _source, _count=undefined)
{
	_count ??= _source.count;
	var _temp = _sorter.Clone(true);
	var _tempA = _sorter;
	var _tempB = _temp;
	var _tempC = _temp;
	tite_sort_init(_sorter, _source, _count);
	for(var i = 0; i < _count-1; i++) {
		tite_oddeven_sort_pass(_tempA, _tempB, i mod 2);
		_tempC = _tempA;
		_tempA = _tempB;
		_tempB = _tempC;		
	}
	
	if (_sorter != _tempC)
		tite_data_copy(_sorter, _temp, true);
	tite_data_free(_temp);
}


function tite_oddeven_sort_pass(_sorterA, _sorterB, _offset=0)
{
	tite_begin();
	tite_shader(tite_op_sort_oddeven);	
	tite_sample("texA", _sorterB);
	tite_floatN("uniTexelA", _sorterB.texel);
	tite_floatN("uniSizeA", _sorterB.size);
	tite_float1("uniOffset", _offset);
	tite_target(_sorterA);
	tite_render();
	tite_finish();
	tite_end();	
}


function tite_mergesort(_sorter, _source, _count=undefined, _helper=undefined) {
	// Sanity check 
	_count ??= _source.count;
	var checkW = power(2, ceil(log2(_source.size[0])));
	var checkH = power(2, ceil(log2(_source.size[1])));
	if (checkW != _source.size[0]) 
	|| (checkH != _source.size[1]) 
	{
		throw($"Source size must be power of two, got: {_source.size}");
	}
	
	// Initialize ping-pong surface
	var _temp = _helper;
	var _temporal = false;
	if (is_undefined(_helper)) 
	{
		_temporal = true;
		_temp = _sorter.Clone();
	}
	var _tempA = _sorter;
	var _tempB = _temp;
	var _tempC = _temp;
	
	// Do the sorting
	tite_sort_init(_sorter, _source, _count);
	tite_oddeven_sort_pass(_temp, _sorter); // first trivial i=2 pass
	for(var i = 4; i <= _count; i *= 2) {
		tite_mergesort_pass(_tempA, _tempB, i);
		_tempC = _tempA;
		_tempA = _tempB;
		_tempB = _tempC;
	}
	
	// Finalization, make sure last pass is for target
	if (_sorter != _tempC)
		tite_data_copy(_sorter, _temp, true);

	if (_temporal)
		tite_data_free(_temp);
}


function tite_mergesort_pass(_dst, _src, _searchSpace) {
	tite_begin();
	tite_shader(tite_op_sort_merge);
	tite_sample("texA", _src);
	tite_floatN("uniTexelA", _src.texel);
	tite_floatN("uniSizeA", _src.size);
	tite_float1("uniSearch", _searchSpace);
	tite_float1("uniRange", _searchSpace / 2);
	tite_target(_dst);
	tite_render();
	tite_finish();
	tite_end();	
}









