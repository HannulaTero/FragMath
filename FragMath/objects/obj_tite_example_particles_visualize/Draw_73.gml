/// @desc VISUALIZE PARTICLES
// feather ignore GM2017
// feather ignore GM1041

with(obj_tite_example_particles_update)
{
	// Preparations.
	var _vbuff = TITE.vtxBufferQuad;
	var _shader = shd_tite_example_particles;
	var _sprUVs = sprite_get_uvs(spr_tite_example_particle, 0);
	var _texture = sprite_get_texture(spr_tite_example_particle, 0);
	var _sampler = shader_get_sampler_index(_shader, "texA");
	var _uniTexelA = shader_get_uniform(_shader, "uniTexelA");
	var _uniUV = shader_get_uniform(_shader, "uniUVs");
	var _uniSize = shader_get_uniform(_shader, "uniSize");
	var _uniColor = shader_get_uniform(_shader, "uniColor");

	// Submit vertex buffer.
	shader_set(_shader);
	gpu_set_blendmode(bm_add);
	texture_set_stage_vs(_sampler, matPos.Texture()); 
	shader_set_uniform_f_array(_uniTexelA, matPos.texel);
	shader_set_uniform_f_array(_uniUV, _sprUVs);
	shader_set_uniform_f(_uniSize, 4, 4);
	shader_set_uniform_f(_uniColor, 1.0, 1.0, 1.0, 1.0);
	tite_batch_quad(matPos.size, _texture);	
	gpu_set_blendmode(bm_normal);
	shader_reset();
}






