// feather ignore GM2017

/// @func	TiteDataLut(_params);
/// @desc	Creates lookup table to be used with TiteGpu lookup operation.
/// @param	{Struct} _params
function TiteDataLut(_params=undefined) : TiteData() constructor 
{
//==========================================================
//
#region VARIABLE DECLARATION.

	
	static __counter = 0;
	self.name = $"TiteDataLut_{__counter++}";
	self.func = undefined;
	self.buffer = undefined;
	self.rangeMin = 0.0;
	self.rangeMax = 1.0;
	self.interpolate = true;
	
	if (_params != undefined)
	{
		tite_data_lut_init(self, _params);
	}


#endregion
// 
//==========================================================
//
#region USER HANDLE METHODS.


	/// @func	Initialize(_params);
	/// @desc	Initializes lookup table parameters.
	/// @param	{Struct}	_params
	/// @return	{Struct.TiteDataLut}
	static Initialize = function(_params={}) 
	{
		return tite_data_lut_init(self, _params);
	};
	
	
	/// @func	Surface();
	/// @desc	Verifies surface exists, and has correct content for lookup.
	/// @return	{Id.Surface}
	static Surface = function()
	{
		return tite_data_lut_surface(self);
	};
	
	
	/// @func	Free();
	/// @desc	
	static Free = function()
	{
		return tite_data_lut_free(self);
	};


#endregion
// 
//==========================================================
}