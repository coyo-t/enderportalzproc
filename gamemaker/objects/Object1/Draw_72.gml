PEV_P = matrix_get(matrix_projection)
PEV_V = matrix_get(matrix_view)

matrix_stack_push(matrix_build(0,0,0, v_pitch, 0, 0, 1,1,1))
matrix_stack_push(matrix_build(0,0,0, 0, v_yaw, 0, 1,1,1))
matrix_stack_push(matrix_build(-x, -y, -z, 0,0,0, 1,1,1))

matrix_set(matrix_view, matrix_stack_top())
matrix_stack_clear()

matrix_set(matrix_projection, matrix_build_projection_perspective_fov(70, room_width/room_height, 0.001, 100))

gpu_push_state()
gpu_set_alphatestenable(true)
gpu_set_alphatestref(0.5)
gpu_set_zwriteenable(true)
gpu_set_ztestenable(true)
//gpu_set_cullmode(cull_clockwise)


