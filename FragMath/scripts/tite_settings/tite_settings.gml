// feather ignore GM2017

#macro	TITE_NAME			"TiteGPU Math"
#macro	TITE				global.g_tite
#macro	TITE_DEBUG_MODE		true
#macro	tite_forceinline	gml_pragma("forceinline")
#macro	tite_encapsulate	with({ outer : other })
#macro	tite_float_max		(power(2.0, +32.0))
#macro	tite_float_min		(power(2.0, -32.0))

// Helper global variables.
TITE = {}; 
TITE.previousShader = [-1];		// Stores so it can be return after calculations are done.
TITE.cumulative = false;		// Store next calculation as cumulative result.

// Debug
TITE.debug = {};
TITE.debug.timer = {};
TITE.debug.timer.times = [];
TITE.debug.timer.messages = [];

// Vertex format and buffers for batchable execution.
TITE.vtxFormatFill = undefined;
TITE.vtxFormatQuad = undefined;
TITE.vtxFormatLine = undefined;
TITE.vtxFormatPoint = undefined;

TITE.vtxBufferFill = undefined;
TITE.vtxBufferQuad = undefined;
TITE.vtxBufferLine = undefined;
TITE.vtxBufferPoint = undefined;

TITE.vtxBatchCount = [9, 9];
TITE.vtxBatchMax = [
	(1 << (TITE.vtxBatchCount[0] - 1)),
	(1 << (TITE.vtxBatchCount[1] - 1)),
];


// Create vertex format and vertex buffer for fullscreen fill.
// These are meant to cover whole render area.
// Calculations are assumed to use simplified vertex shader, 
// so it won't add any projections. 
// Vertex buffer assumes pr_trianglestrip.
{
	vertex_format_begin();
	vertex_format_add_position();
	TITE.vtxFormatFill = vertex_format_end();
	TITE.vtxBufferFill = vertex_create_buffer();
	var _vbuff = TITE.vtxBufferFill;
	vertex_begin(_vbuff, TITE.vtxFormatFill);
	vertex_position(_vbuff, -1.0, -1.0);
	vertex_position(_vbuff, +1.0, -1.0);
	vertex_position(_vbuff, -1.0, +1.0);
	vertex_position(_vbuff, +1.0, +1.0);
	vertex_end(_vbuff);
	vertex_freeze(_vbuff);
	/* 
	// Funny small optimization to cover whole render area with single triangle.
	// Fragments are usually done in 2x2, so triangle edges have bit overhead.
	// So this avoid having edge, and uses only single triangle.
	vertex_position(_vbuff, -1.0, -1.0);
	vertex_position(_vbuff, +3.0, -1.0);
	vertex_position(_vbuff, -1.0, +3.0);
	*/
}

// As GM doesn't support instanced rendering, so
// some pre-made vertex buffers are created for batching.
// Points, lines and quads can work as computational units, 
// which are moved around in vertex shader.
{
	// Quad vertex buffer.
	vertex_format_begin();
	vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);
	vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);
	TITE.vtxFormatQuad = vertex_format_end();
	TITE.vtxBufferQuad = array_create(TITE.vtxBatchCount[0]);
	
	// Line vertex buffer.
	vertex_format_begin();
	vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);
	vertex_format_add_custom(vertex_type_float1, vertex_usage_texcoord);
	TITE.vtxFormatLine = vertex_format_end();
	TITE.vtxBufferLine = array_create(TITE.vtxBatchCount[0]);
	
	// Point vertex buffer.
	vertex_format_begin();
	vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);
	TITE.vtxPointFormat = vertex_format_end();
	TITE.vtxBufferPoint = array_create(TITE.vtxBatchCount[0]);
	
	for(var i = 0; i < TITE.vtxBatchCount[0]; i++)
	{
		TITE.vtxBufferQuad[i] = array_create(TITE.vtxBatchCount[1]); 
		TITE.vtxBufferLine[i] = array_create(TITE.vtxBatchCount[1]); 
		TITE.vtxBufferPoint[i] = array_create(TITE.vtxBatchCount[1]); 
		
		for(var j = 0; j < TITE.vtxBatchCount[1]; j++)
		{
			var _w = (1 << i);
			var _h = (1 << j);
			var _vtxBufferQuad = vertex_create_buffer();
			var _vtxBufferLine = vertex_create_buffer();
			var _vtxBufferPoint = vertex_create_buffer();
			vertex_begin(_vtxBufferQuad, TITE.vtxFormatQuad);
			vertex_begin(_vtxBufferLine, TITE.vtxFormatLine);
			vertex_begin(_vtxBufferPoint, TITE.vtxPointFormat);
			
			for(var ii = 0; ii < _w; ii++) {
			for(var jj = 0; jj < _h; jj++) {
				// Create quad triangles.
				vertex_float2(_vtxBufferQuad, ii, jj); vertex_float2(_vtxBufferQuad, 0, 0); 
				vertex_float2(_vtxBufferQuad, ii, jj); vertex_float2(_vtxBufferQuad, 1, 0); 
				vertex_float2(_vtxBufferQuad, ii, jj); vertex_float2(_vtxBufferQuad, 1, 1); 
				vertex_float2(_vtxBufferQuad, ii, jj); vertex_float2(_vtxBufferQuad, 1, 1); 
				vertex_float2(_vtxBufferQuad, ii, jj); vertex_float2(_vtxBufferQuad, 0, 1); 
				vertex_float2(_vtxBufferQuad, ii, jj); vertex_float2(_vtxBufferQuad, 0, 0); 
				// Create both ends of line.
				vertex_float2(_vtxBufferLine, ii, jj); vertex_float1(_vtxBufferLine, 0); 
				vertex_float2(_vtxBufferLine, ii, jj); vertex_float1(_vtxBufferLine, 1); 
				// Create point.
				vertex_float2(_vtxBufferPoint, ii, jj);
			}}
			
			vertex_end(_vtxBufferQuad);
			vertex_end(_vtxBufferLine);
			vertex_end(_vtxBufferPoint);
			vertex_freeze(_vtxBufferQuad);
			vertex_freeze(_vtxBufferLine);
			vertex_freeze(_vtxBufferPoint);
			TITE.vtxBufferQuad[i][j] = _vtxBufferQuad;
			TITE.vtxBufferLine[i][j] = _vtxBufferLine;
			TITE.vtxBufferPoint[i][j] = _vtxBufferPoint;
		}
	}
}








