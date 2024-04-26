/// @desc DECLARATION.
// feather ignore GM2017

// Prepare GPU datablocks
lhsGpu = new TiteData(64, 784, { name : "Matrix LHS", format : surface_r32float } );
rhsGpu = new TiteData(784, 32, { name : "Matrix RHS", format : surface_r32float } );
outGpu = new TiteData(64, 32, { name : "Matrix OUT", format : surface_r32float } );

// Prepare CPU datablocks.
dtype = tite_format_buffer_dtype(lhsGpu.format);
dsize = buffer_sizeof(dtype);
lhsCpu = buffer_create(lhsGpu.Bytes(), buffer_wrap, 1);
rhsCpu = buffer_create(rhsGpu.Bytes(), buffer_wrap, 1);
outCpu = buffer_create(outGpu.Bytes(), buffer_wrap, 1);
axis = 0;

// To read results from GPU and compare them against.
result = buffer_create(outGpu.Bytes(), buffer_wrap, 1);

// Timing.
timeGpu = 0;
timeCpu = 0;