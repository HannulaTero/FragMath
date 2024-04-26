/// @desc GPU CALCULATIONS.
// feather ignore GM2017

// Randomize input.
if (keyboard_check_pressed(ord("R")))
{
	// Randomize input GPU values.
	lhsGpu.Randomize(-2.5, +2.5);
	rhsGpu.Randomize(-2.5, +2.5);
	outGpu.Set(0.0);
	
	// Copy over to CPU to have same inputs.
	lhsGpu.ToBuffer(lhsCpu);
	rhsGpu.ToBuffer(rhsCpu);
}


// Calculate GPU matrix dot product.
if (keyboard_check_pressed(ord("2")))
{
	outGpu.Dot(lhsGpu, rhsGpu);
	outGpu.ToBuffer(result);
}

