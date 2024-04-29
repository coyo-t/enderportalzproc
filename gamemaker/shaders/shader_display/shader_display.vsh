//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec4 v_vCo;

varying vec3 v_incoming;
varying vec3 v_position;

vec4 projection_from_position (vec4 position)
{
	vec4 projection = position * 0.5;
	projection.xy = vec2(projection.x + projection.w, projection.y + projection.w);
	projection.zw = position.zw;
	return projection;
}

void main()
{
	vec4 object_space_pos = vec4(in_Position, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

	v_vColour = in_Colour;
	v_vTexcoord = in_TextureCoord;
	v_vCo = projection_from_position(gl_Position);
	
	{
		mat4 vm = gm_Matrices[MATRIX_VIEW];
		mat4 k = gm_Matrices[MATRIX_VIEW];
		vec3 pp = k[3].xyz;
		
		v_position = -vec3(
			dot(pp, vec3(vm[0][0], vm[0][1], vm[0][2])),
			dot(pp, vec3(vm[1][0], vm[1][1], vm[1][2])),
			dot(pp, vec3(vm[2][0], vm[2][1], vm[2][2]))
		);
		v_incoming = -v_position;
		v_position = (gm_Matrices[MATRIX_WORLD]*object_space_pos).xyz - v_position;
		//v_position = (gm_Matrices[MATRIX_PROJECTION]*vec4(v_position, 1.0)).xyz;
	}
	

}
