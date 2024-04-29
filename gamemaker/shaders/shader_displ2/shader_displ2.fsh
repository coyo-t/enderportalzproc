//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

vec3 palette (float n)
{
	float ss = sign(n);
	float gg = sin(n * 0.950795);
	float rb = abs(n);
	return clamp(vec3(
		pow(n, 6.27) * n,
		gg,
		pow(rb, 1.25) * pow(abs(gg), 0.15) * n
	), vec3(-1.0), vec3(1.0));
}

void main()
{
	float pix = texture2D( gm_BaseTexture, v_vTexcoord ).r;
	gl_FragColor = v_vColour * vec4(vec3(pix*0.5+0.5), 1.0);
	//gl_FragColor = v_vColour * vec4(vec3(0.5)+palette(pix*8.0), 1.0);
}
