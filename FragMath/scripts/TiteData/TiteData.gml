// feather ignore GM2017

/// @func	TiteData(_params);
/// @desc	Data-block which lives in GPU. Can be thought as MxN matrix.
/// @param	{Struct}	_params		Parameters for creating data. Check initialization method.
function TiteData(_params=undefined) constructor
{
//==========================================================
//
#region VARIABLE DECLARATION.


	static __counter = 0;
	self.name = $"TiteData_{__counter++}"
	self.size = [1, 1];
	self.texel = [1.0, 1.0];
	self.count = 1;
	self.format = surface_rgba32float;
	self.repetive = true;
	self.interpolate = false;
	self.depthDisabled = true;
	self.surface = -1;
	
	// Initialization.
	if (_params != undefined) 
	{
		return tite_data_init(self, _params);
	}
	
	
#endregion
// 
//==========================================================
//
#region USER HANDLE METHODS.


	/// @func	Initialize(_params);
	/// @desc	(Re)Initialize data with given parameters..
	/// @param	{Struct}	_params		[Optional] format and name.
	/// @return	{Struct.TiteData}
	static Initialize = function(_params={})
	{
		return tite_data_init(self, _params);
	};
	

	/// @func	Surface();
	/// @desc	Return surface, creates if necessary.
	/// @return {Id.Surface}
	static Surface = function()
	{
		return tite_data_surface(self);
	};
	
	
	/// @func	Texture();
	/// @desc	Return texture for surface.
	/// @return {Pointer.Texture}
	static Texture = function()
	{
		return surface_get_texture(self.Surface());
	};


	/// @func	Bytes();
	/// @desc	Returns how many bytes the gpu datablock requires to be put into buffer.
	/// @return {Real}
	static Bytes = function()
	{
		return self.size[0] * self.size[1] * tite_format_bytes(self.format);
	};
	
	
	/// @func	BufferType();
	/// @desc	Returns what buffer datatype should be used to read values.
	/// @return {Constant.BufferDataType}
	static BufferType = function()
	{
		return tite_format_buffer_dtype(self.format);
	};

	
	/// @func	ToBuffer(_buffer, _offset);
	/// @desc	Put contents of gpu datablock into given buffer.
	/// @param	{Id.Buffer}	_buffer		If not given, one is created for you. 
	/// @param	{Real}		_offset 
	/// @return {Id.Buffer}
	static ToBuffer = function(_buffer=undefined, _offset=0)
	{
		_buffer ??= buffer_create(self.Bytes(), buffer_fixed, 1);
		buffer_get_surface(_buffer, self.Surface(), _offset);
		buffer_seek(_buffer, buffer_seek_start, 0);
		return _buffer;
	};
	
	
	/// @func	FromBuffer(_buffer, _offset);
	/// @desc	Put contents of given buffer into gpu datablock.
	/// @param	{Id.Buffer}	_buffer
	/// @param	{Real}		_offset 
	/// @return {Struct.TiteData}
	static FromBuffer = function(_buffer, _offset=0)
	{
		buffer_set_surface(_buffer, self.Surface(), _offset);
		buffer_seek(_buffer, buffer_seek_start, 0);
		return self;
	};
	
	
	/// @func	FromSprite(_sprite, _image);
	/// @desc	Put contents of given buffer into gpu datablock.
	/// @param	{Asset.GMSprite}	_sprite
	/// @param	{Real}				_image 
	/// @return {Struct.TiteData}
	static FromSprite = function(_sprite, _image=0)
	{
		tite_begin();
		tite_target(self);
		tite_render_sprite(_sprite, _image);
		tite_finish();
		tite_end();
		return self;
	};
	
	
	/// @func	Copy(_src, _copyContent);
	/// @desc	Copies structure from other data, optionally also copy the contents.
	/// @param	{Struct.TiteData}	_src
	/// @param	{Bool}				_copyContent
	/// @return {Struct.TiteData}
	static Copy = function(_src, _copyContent=false) 
	{
		return tite_data_copy(self, _src, _copyContent);
	};
	
	
	/// @func	Clone(_copyContent);
	/// @desc	Creates clone of data, optionally also copy the contents.
	/// @param	{Bool}	_copyContent Default is false.
	/// @return {Struct.TiteData}
	static Clone = function(_copyContent=false) 
	{
		return new TiteData().Copy(self, _copyContent);
	};
	
	
	/// @func	Draw(_x, _y, _params);
	/// @desc	Draws surface with given parameters.
	/// @param	{Real}		_x
	/// @param	{Real}		_y
	/// @param	{Struct}	_params	[Optional]
	/// @return {Struct.TiteData}
	static Draw = function(_x=0, _y=0, _params={}) 
	{
		// feather ignore GM1045
		return tite_draw(self, _x, _y, _params);
	};
	
	
	/// @func	Resize(_params);
	/// @desc	Reallocates data in the gpu, destroyes prevous one.
	/// @param	{Any}	_params
	static Resize = function(_params)
	{
		return tite_data_resize(self, _params);
	};
	
	
	/// @func	Exists();
	/// @desc	Checks whether data exists in gpu.
	static Exists = function()
	{
		return tite_data_exists(self);
	};
	

	/// @func	Free();
	/// @desc	Frees the surface in data from gpu.
	/// @return {Struct.TiteData}
	static Free = function() 
	{
		return tite_data_free(self);
	};
	
	
#endregion
// 
//==========================================================
//
#region MATH: SETTINGS
	
	
	/// @func	Cumulative();
	/// @desc	Set next calculation as cumulative result.
	/// @return {Struct.TiteData}
	static Cumulative = function()
	{
		tite_set_cumulative(true);
		return self;
	};
	
	
	/// @func	Interpolate(_interpolate);
	/// @desc	Set next calculation inputs interpolative.
	/// @param	{Bool}	_interpolate
	/// @return {Struct.TiteData}
	static Interpolate = function(_interpolate)
	{
		self.interpolate = _interpolate;
		return self;
	};
	
	
	/// @func	Repetive(_repetive);
	/// @desc	Set next calculation inputs repetive.
	/// @param	{Bool}	_repetive
	/// @return {Struct.TiteData}
	static Repetive = function(_repetive)
	{
		self.repetive = _repetive;
		return self;
	};
	
	
	/// @func	DepthDisable(_disabled);
	/// @desc	Set whether stores depth buffer.
	/// @param	{Bool}	_disabled
	/// @return {Struct.TiteData}
	static DepthDisable = function(_disabled)
	{
		self.depthDisabled = _disabled;
		return self;
	};
	
	
#endregion
// 
//==========================================================
//
#region MATH: PIECEWISE BINARY OPERATIONS.
	
	
	/// @func	Binary(_lhs, _rhs, _op);
	/// @desc	General piecewise binary operator executer.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @param	{Asset.GMShader}	_op		TiteGpu shader
	/// @return {Struct.TiteData}
	static Binary = function(_lhs, _rhs, _op) 
	{
		if (_rhs == undefined)
		{
			_rhs = _lhs;
			_lhs = self;
		}
		return tite_binary(self, _lhs, _rhs, _op);	
	};
	
	
	/// @func	Add(_lhs, _rhs);
	/// @desc	Does piecewise addition between two matrices.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @return {Struct.TiteData}
	static Add = function(_lhs, _rhs=undefined) 
	{ 
		return Binary(_lhs, _rhs, tite_op_add);
	};
	
	
	/// @func	Distance(_lhs, _rhs);
	/// @desc	Calculates piecewise distance values. More useful with vec4 values.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @return {Struct.TiteData}
	static Distance	= function(_lhs, _rhs=undefined) 
	{ 
		return Binary(_lhs, _rhs, tite_op_dist); 
	};
	
	
	/// @func	Div(_lhs, _rhs);
	/// @desc	Does piecewise division between two matrices.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @return {Struct.TiteData}
	static Div = function(_lhs, _rhs=undefined) 
	{ 
		return Binary(_lhs, _rhs, tite_op_div); 
	};
	
	
	/// @func	Max(_lhs, _rhs);
	/// @desc	Does piecewise maximum between two matrices.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @return {Struct.TiteData}
	static Max = function(_lhs, _rhs=undefined) 
	{ 
		return Binary(_lhs, _rhs, tite_op_max); 
	};
	
	
	/// @func	Min(_lhs, _rhs);
	/// @desc	Does piecewise minimum between two matrices.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @return {Struct.TiteData}
	static Min = function(_lhs, _rhs=undefined) 
	{ 
		return Binary(_lhs, _rhs, tite_op_min); 
	};
	
	
	/// @func	Mul(_lhs, _rhs);
	/// @desc	Does piecewise mupliplication between two matrices.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @return {Struct.TiteData}
	static Mul = function(_lhs, _rhs=undefined) 
	{ 
		return Binary(_lhs, _rhs, tite_op_mul); 
	};
	
	
	/// @func	Pow(_lhs, _rhs);
	/// @desc	Does piecewise power operation between two matrices.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @return {Struct.TiteData}
	static Pow = function(_lhs, _rhs=undefined) 
	{ 
		return Binary(_lhs, _rhs, tite_op_pow); 
	};
	
	
	/// @func	Root(_lhs, _rhs);
	/// @desc	Does piecewise root operation with two matrices.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @return {Struct.TiteData}
	static Root = function(_lhs, _rhs=undefined) 
	{ 
		return Binary(_lhs, _rhs, tite_op_root); 
	};
	
	
	/// @func	Sub(_lhs, _rhs);
	/// @desc	Does piecewise subtraction between two matrices.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @return {Struct.TiteData}
	static Sub = function(_lhs, _rhs=undefined) 
	{ 
		return Binary(_lhs, _rhs, tite_op_sub); 
	};
	
	
#endregion
// 
//==========================================================
//
#region MATH: PIECEWISE UNARY OPERATIONS.
	
	
	/// @func	Unary(_src, _op);
	/// @desc	General unary operator executer.
	/// @param	{Struct.TiteData}	_src
	/// @param	{Asset.GMShader}	_op		TiteGpu shader
	/// @return {Struct.TiteData}
	static Unary = function(_src, _op) 
	{
		_src ??= self;
		return tite_unary(self, _src, _op);
	};
	
	
	/// @func	Acos(_src);
	/// @desc	Does piecewise trigonometric arc cosine operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Acos = function(_src=undefined) 
	{
		return Unary(_src, tite_op_acos); 
	};
	
	
	/// @func	Asin(_src);
	/// @desc	Does piecewise trigonometric arc sine operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Asin = function(_src=undefined) 
	{
		return Unary(_src, tite_op_asin); 
	};
	
	
	/// @func	Atan(_src);
	/// @desc	Does piecewise trigonometric arc tangent operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Atan = function(_src=undefined) 
	{
		return Unary(_src, tite_op_atan); 
	};
	
	
	/// @func	Cos(_src);
	/// @desc	Does piecewise trigonometric cosine operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Cos = function(_src=undefined) 
	{
		return Unary(_src, tite_op_cos); 
	};
	
	
	/// @func	Exp(_src);
	/// @desc	Does piecewise power(euler, n) operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Exp = function(_src=undefined) 
	{
		return Unary(_src, tite_op_exp); 
	};
	
	
	/// @func	Log(_src);
	/// @desc	Does piecewise logarithmic operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Log = function(_src=undefined) 
	{
		return Unary(_src, tite_op_log); 
	};
	
	
	/// @func	Neg(_src);
	/// @desc	Does piecewise negation operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Neg = function(_src=undefined) 
	{
		return Unary(_src, tite_op_neg); 
	};
	
	
	/// @func	Relu(_src);
	/// @desc	Does piecewise rectified linear unit operation: max(0, x).
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Relu = function(_src=undefined) 
	{
		return Unary(_src, tite_op_relu); 
	};
	
	
	/// @func	Sigmoid(_src);
	/// @desc	Does piecewise sigmoid operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Sigmoid = function(_src=undefined) 
	{
		return Unary(_src, tite_op_sigmoid); 
	};
	
	
	/// @func	Sin(_src);
	/// @desc	Does piecewise trigonometric sine operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Sin = function(_src=undefined) 
	{
		return Unary(_src, tite_op_sin); 
	};
	
	
	/// @func	Sqr(_src);
	/// @desc	Does piecewise squaring operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Sqr = function(_src=undefined) 
	{
		return Unary(_src, tite_op_sqr); 
	};
	
	
	/// @func	Sqrt(_src);
	/// @desc	Does piecewise square root operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Sqrt = function(_src=undefined) 
	{ 
		return Unary(_src, tite_op_sqrt); 
	};
	
	
	/// @func	Tan(_src);
	/// @desc	Does piecewise trigonometric tangent operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Tan = function(_src=undefined) 
	{ 
		return Unary(_src, tite_op_tan); 
	};
	
	
	/// @func	Tanh(_src);
	/// @desc	Does piecewise trigonometric hyperbolic tangent operation.
	/// @param	{Struct.TiteData}	_src
	/// @return {Struct.TiteData}
	static Tanh = function(_src=undefined) 
	{ 
		return Unary(_src, tite_op_tanh); 
	};
	
	
#endregion
// 
//==========================================================
//
#region MATH: OTHER OPERATIONS.


	/// @func	Dot(_lhs, _rhs, _axis);
	/// @desc	Matrix dot product, sumreduces given axis.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @param	{Array<Real>}		_axis
	/// @return {Struct.TiteData}
	static Dot = function(_lhs=undefined, _rhs=undefined, _axis=[1, 0]) 
	{
		_lhs ??= self;
		_rhs ??= self;
		return tite_dot(self, _lhs, _rhs, _axis);
	};


	/// @func	Lut(_src, _lut);
	/// @desc	Uses Look up table to select new value. 
	/// @param	{Struct.TiteData}		_src
	/// @param	{Struct.TiteGpuLookup}	_lut
	static Lut = function(_src=undefined, _lut=undefined)
	{
		_src ??= self;
		return tite_lut(self, _src, _lut);
	};


	/// @func	Clamp(_src, _min, _max);
	/// @desc	Clamps values to given range.
	/// @param	{Struct.TiteData}	_src
	/// @param	{Any}				_min
	/// @param	{Any}				_max
	/// @return {Struct.TiteData}
	static Clamp = function(_src=undefined, _min=undefined, _max=undefined) 
	{
		_src ??= self;
		return tite_clamp(self, _src, _min, _max);
	};
	
	
	/// @func	Mix(_lhs, _rhs, _rate);
	/// @desc	Lerps two matrices with given rate.
	/// @param	{Struct.TiteData}	_lhs
	/// @param	{Struct.TiteData}	_rhs
	/// @param	{Any}				_rate
	/// @return {Struct.TiteData}
	static Mix = function(_lhs=undefined, _rhs=undefined, _rate=undefined) 
	{
		_lhs ??= self;
		_rhs ??= self;
		return tite_mix(self, _lhs, _rhs, _rate);
	};


	/// @func	Offset(_src, _offset);
	/// @desc	Adds offset to given data values.
	/// @param	{Struct.TiteData}	_src
	/// @param	{Any}				_offset
	/// @return {Struct.TiteData}
	static Offset = function(_src=undefined, _offset=undefined) 
	{
		_src ??= self;
		return tite_offset(self, _src, _offset);
	};


	/// @func	Scale(_src, _factor);
	/// @desc	Scales values of given datablock.
	/// @param	{Struct.TiteData}	_src
	/// @param	{Any}				_factor
	/// @return {Struct.TiteData}
	static Scale = function(_src=undefined, _factor=undefined) 
	{
		_src ??= self;
		return tite_scale(self, _src, _factor);
	};
	

	/// @func	Normalize(_src, _min, _max);
	/// @desc	Normalizes values of data to given range, but does not clamp if it exceeds.
	/// @param	{Struct.TiteData}	_src
	/// @param	{Any}				_min
	/// @param	{Any}				_max
	/// @return {Struct.TiteData}
	static Normalize = function(_src=undefined, _min=undefined, _max=undefined)
	{
		_src ??= self;
		return tite_normalize(self, _src, _min, _max);
	};	


	/// @func	Set(_values);
	/// @desc	Set all data values to given value
	/// @param	{Any}	_values	
	/// @return {Struct.TiteData}
	static Set = function(_values=undefined) 
	{
		return tite_set(self, _values);
	};


	/// @func	Randomize(_min, _max, _seed);
	/// @desc	Randomizes content of datablock.
	/// @param	{Any}	_min
	/// @param	{Any}	_max
	/// @param	{Any}	_seed
	/// @return {Struct.TiteData}
	static Randomize = function(_min=undefined, _max=undefined, _seed=undefined)
	{
		return tite_randomize(self, _min, _max, _seed);
	};	

	
#endregion
// 
//==========================================================
}















