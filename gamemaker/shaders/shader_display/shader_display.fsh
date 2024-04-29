//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec4 v_vCo;

varying vec3 v_incoming;
varying vec3 v_position;

uniform sampler2D COLORS;
uniform sampler2D sampler1;
uniform float GameTime;

mat2 mat2_rotate_z(float rad) {
	float si = sin(rad);
	float co = cos(rad);
	return mat2(
		co, -si,
		si, co
	);
}

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

vec3 samplec (int i)
{
	return texture2D(COLORS, vec2((float(i)+0.5)/16.0, 0.5)).rgb;
}

const int EndPortalLayers = 16;

const mat3 SCALE_TRANSLATE2 = mat3(
	0.5, 0.0, 0.25,
	0.0, 0.5, 0.25,
	0.0, 0.0, 1.0
);

mat3 end_portal_layer2 (float layer)
{
	mat2 rotate = mat2_rotate_z(radians((layer * layer * 4321.0 + layer * 9.0) * 2.0));

	mat2 scale = mat2(((4.5 - (layer*2.95)) / 4.0) * 2.0);

	return mat3(scale * rotate) * SCALE_TRANSLATE2;
}

vec3 screen_v3 (in vec3 a, in vec3 b)
{
	return 1.0 - (1.0 - a) * (1.0 - b);
}

void main ()
{
	float pix = texture2D(gm_BaseTexture, v_vTexcoord).r;
	float zexer =  pow(pix, 2.0)*sign(pix)* 4.5;
	
	vec3 vpn = normalize(v_position);
	vec2 yeowch = vpn.xz/vpn.y * (1.0 + zexer);
	vec3 color = vec3(0.0);
	for (int i = 0; i < EndPortalLayers; i++)
	{
		vec2 yeow2 = (yeowch)*(v_incoming.y-(1.0-float(i)/15.0)*2.0-0.25)-v_incoming.xz;
		vec3 cc = samplec(i) * ((1.0 - float(i) / 15.0) * 0.5 + 0.5);
		vec3 sam = end_portal_layer2(float(i+1)) * vec3(yeow2, 1.0);
		vec3 cc2 = texture2D(sampler1, (sam.xy+vec2(0.0, GameTime*0.05+float(i))) * 0.025).rgb * cc;
		
		float lenn = max(length(yeow2)-0.5, 0.0)*0.45;
		color += mix(vec3(0.0), cc2, clamp(1.0-pow(lenn, 4.2), 0.0, 1.0));
	}
	vec3 picky = palette(pix*8.0)*0.09;
	gl_FragColor = vec4(screen_v3(color, picky), 1.0);
	
}
