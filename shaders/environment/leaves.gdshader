shader_type spatial;
render_mode blend_mix, cull_disabled, depth_test_disabled;

// --

uniform float sway_speed = 2.0;
uniform float sway_strengh = 0.5;
uniform float sway_phase_offset = 0.5;

// --

varying float blend_progress;

// --

void vertex() {
	blend_progress = INSTANCE_CUSTOM.r;
	
	float time_val = TIME * sway_speed + (VERTEX.x + VERTEX.z) * sway_phase_offset;
	float wave = sin(time_val);

	vec3 wind_offset = vec3(
		wave * sway_strengh,
		0.0,
		wave * sway_strengh
	);

	VERTEX.xyz += wind_offset * COLOR.r;
}

// --

uniform sampler2D texture_sick;
uniform sampler2D texture_healed;
uniform float blend;
const float max_blend = 1.0;

uniform vec2 player_screen_pos;
uniform vec3 player_position;
uniform vec3 camera_forward;

uniform vec2 position_adjustment = vec2(0.0);
uniform float radius  = 0.15;
uniform float smoothness = 0.07;

// --


void fragment(){
	vec4 col_a = texture(texture_sick, UV);
	vec4 col_b = texture(texture_healed, UV);
	
	vec3 final_color;
	float alpha;
	
	if ((blend_progress == 0.0) || (blend_progress == 1.0)) {
		final_color = blend_progress == 0.0 ? col_a.rgb : col_b.rgb;
		alpha = blend_progress == 0.0 ? col_a.a : col_b.a;
	} else {
		final_color = mix(col_a.rgb, col_b.rgb, blend_progress);
		alpha = mix(col_a.a, col_b.a, blend_progress);
	}
	
	//float aspect_ratio = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
	//vec2 correction = vec2(aspect_ratio, 1.0);
	//vec2 screen_uv = FRAGCOORD.xy / VIEWPORT_SIZE.xy;

	//float dist = length(
		//(screen_uv - player_screen_pos + position_adjustment) * correction
	//);
	//float outside_circle = smoothstep(radius - smoothness, radius, dist);
	//vec3 to_player = normalize(player_position - NODE_POSITION_WORLD);
	//float facing = dot(to_player, camera_forward);
	
	//if (facing < 0.0)
	//{
		//alpha *= outside_circle;
	//}
	
	ALBEDO = final_color;
	ALPHA = alpha;
	//ALPHA_SCISSOR_THRESHOLD = 0.1;
}