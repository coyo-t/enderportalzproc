
if keyboard_check_pressed(vk_backspace)
{
	end_portal_clear_buffers()
}

var t = get_timer()

var tickrate = 20
if t >= next_think_time// and false
{
	next_think_time = t + (1000000 / tickrate)
	end_portal_tick(get_timer()/1000000)
	surface_dirty = true
}

begin
	if keyboard_check_pressed(vk_escape)
	{
		window_mouse_set_locked(!window_mouse_get_locked())
	}

	if window_mouse_get_locked()
	{
		var msens = 1 / 4
		v_yaw   += window_mouse_get_delta_x() * msens
		v_pitch = clamp(v_pitch + window_mouse_get_delta_y() * msens, -90, 90)
	}
	
	var siy = dsin(v_yaw)
	var coy = dcos(v_yaw)
	//var sip = dsin(v_pitch)
	//var cop = dcos(v_pitch)
	
	var dx = keyboard_check(ord("D"))-keyboard_check(ord("A"))
	var dz = keyboard_check(ord("W"))-keyboard_check(ord("S"))
	var mag = power(dx, 2) + power(dz, 2)
	if mag > 0 and mag != 1
	{
		mag = 1 / sqrt(mag)
		dx *= mag
		dz *= mag
	}
	var dy = (keyboard_check(vk_space)-keyboard_check(vk_shift))
	
	var dt = delta_time / 1000000
	var spd = 4
	x += (coy * dx + siy * dz) * spd * dt
	y += dy * spd * dt
	z += (coy * dz - siy * dx) * spd * dt
end
