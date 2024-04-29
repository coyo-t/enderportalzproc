#macro print show_debug_message
x = 0
y = 1
z = -1

v_yaw   = 0
v_pitch = 0

PEV_V = -1
PEV_P = -1

vertex_format_begin()
vertex_format_add_position_3d()
vertex_format_add_colour()
vertex_format_add_texcoord()
FORMAT = vertex_format_end()
VB = vertex_create_buffer()

function vertex (_x, _y, _z, _u, _v)
{
	vertex_position_3d(VB, _x, _y, _z)
	vertex_colour(VB, c_white, 1.0)
	vertex_texcoord(VB, _u, _v)
}


wide = 16*3
tall = wide

end_portal_init(wide, tall)

display_buffer = buffer_create(end_portal_get_array_size()*buffer_sizeof(buffer_f32), buffer_fixed, 1)


surface_dirty = true
surface = -1

next_think_time = -1


function ensure_surface ()
{
	if not surface_exists(surface)
	{
		var dp = surface_get_depth_disable()
		surface_depth_disable(true)
		surface = surface_create(wide, tall, surface_r32float)
		surface_dirty = true
		surface_depth_disable(dp)
	}
	
	if surface_dirty
	{
		var sz = buffer_get_size(display_buffer)
		end_portal_get_buffer(buffer_get_address(display_buffer))
		buffer_set_used_size(display_buffer, sz)
		buffer_set_surface(display_buffer, surface, 0)
		surface_dirty = false
	}
	return surface_exists(surface)
}

function draw_end_portal_frame (_x, _y, _z)
{
	vertex_begin(VB, FORMAT)
	var eph = 13/16
	var x0 = _x
	var y0 = _y
	var z0 = _z
	var x1 = _x + 1
	var y1 = _y + eph
	var z1 = _z + 1
	vertex(_x, y1, _z, 0, 0)
	vertex(x1, y1, _z, 1, 0)
	vertex(_x, y1, z1, 0, 1)
	vertex(x1, y1, z1, 1, 1)
	vertex_end(VB)
	vertex_submit(VB, pr_trianglestrip, sprite_get_texture(spr_end_portal_frame_top, 0))

	var vy = 1-eph
	vertex_begin(VB, FORMAT)
	vertex(x0, y1, z0, 0, vy)
	vertex(x0, y0, z0, 0, 1)
	vertex(x1, y1, z0, 1, vy)
	vertex(x1, y0, z0, 1, 1)
	
	vertex(x1, y1, z1, 0, vy)
	vertex(x1, y0, z1, 0, 1)
	
	vertex(x0, y1, z1, 1, vy)
	vertex(x0, y0, z1, 1, 1)
	
	vertex(x0, y1, z0, 0, vy)
	vertex(x0, y0, z0, 0, 1)
	
	
	vertex_end(VB)
	vertex_submit(VB, pr_trianglestrip, sprite_get_texture(spr_end_portal_frame_side, 0))
}
