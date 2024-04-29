
if ensure_surface()
{
	var sh = shader_display
	shader_set(sh)
	
	var ramptex = shader_get_sampler_index(sh, "COLORS")
	gpu_set_tex_repeat_ext(ramptex, false)
	texture_set_stage(ramptex, sprite_get_texture(spr_end_portal_ramp, 0))
	texture_set_stage(shader_get_sampler_index(sh, "sampler1"), sprite_get_texture(spr_end_portal, 0))
	
	shader_set_uniform_f(shader_get_uniform(sh, "GameTime"), get_timer()/1000000)
	gpu_set_texrepeat(true)
	
	var sz = 1
	var ssz = 3/2
	vertex_begin(VB, FORMAT)
	
	vertex(-ssz, 0, -ssz, 0,  0)
	vertex(+ssz, 0, -ssz, sz, 0)
	vertex(-ssz, 0, +ssz, 0,  sz)
	vertex(+ssz, 0, +ssz, sz, sz)
	//gpu_set_tex_filter_ext(shader_get_sampler_index(sh, "gm_BaseTexture"), true)
	vertex_end(VB)
	vertex_submit(VB, pr_trianglestrip, surface_get_texture(surface))
	
	gpu_set_texrepeat(false)
	shader_reset()
}

matrix_set(matrix_world, matrix_build(-0.5, -0.5, -0.5, 0,0,0, 1,1,1))

draw_end_portal_frame(-2, 0, -1)
draw_end_portal_frame(-2, 0, 0)
draw_end_portal_frame(-2, 0, 1)


draw_end_portal_frame(2, 0, -1)
draw_end_portal_frame(2, 0, 0)
draw_end_portal_frame(2, 0, 1)


draw_end_portal_frame(-1, 0, -2)
draw_end_portal_frame(0, 0, -2)
draw_end_portal_frame(1, 0, -2)


draw_end_portal_frame(-1, 0, 2)
draw_end_portal_frame(0, 0, 2)
draw_end_portal_frame(1, 0, 2)


matrix_set(matrix_world, matrix_build_identity())

//begin // axis
//	var xofs = -1
//	var zofs = -1
//	var yofs = -1+0.001
//	var linesz = 16
//	gpu_push_state()
//	gpu_set_zfunc(cmpfunc_always)
//	draw_primitive_begin(pr_linelist)
//	gpu_set_depth(zofs)
//	draw_vertex_colour(xofs, yofs, c_red, 1)
//	draw_vertex_colour(xofs+linesz, yofs, c_red, 1)
//	draw_vertex_colour(xofs, yofs, c_yellow, 1)
//	draw_vertex_colour(xofs, linesz+yofs, c_yellow, 1)
//	draw_vertex_colour(xofs, yofs, c_teal, 1)
//	gpu_set_depth(zofs+linesz)
//	draw_vertex_colour(xofs, yofs, c_teal, 1)
//	draw_primitive_end()
	
//	gpu_set_depth(0)
//	gpu_pop_state()
//end


