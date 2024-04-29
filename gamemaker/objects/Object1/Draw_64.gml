

if keyboard_check_pressed(vk_f3)
{
	score = 1-score
}

if score == 1
{
	if ensure_surface()
	{
		var sz = 1
		shader_set(shader_displ2)
		gpu_set_tex_repeat(true)
		draw_primitive_begin_texture(pr_trianglestrip, surface_get_texture(surface))
		draw_vertex_texture(0, 0, 0, 0)
		draw_vertex_texture(256, 0, sz, 0)
		draw_vertex_texture(0, 256, 0, sz)
		draw_vertex_texture(256, 256, sz, sz)
		draw_primitive_end()
		gpu_set_tex_repeat(false)
		shader_reset()
	}
}
