shader_type spatial;
render_mode cull_disabled;

uniform float wind_speed : hint_range(0.1, 5.0) = 1.2;
uniform float wind_strength : hint_range(0.0, 2.0) = 0.3;
uniform float wind_frequency : hint_range(0.1, 10.0) = 2.5;

varying float height_factor;

void vertex() {
	height_factor = 1.0 - UV.y;
	
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	float wave = sin(TIME * wind_speed + (world_pos.x + world_pos.z) * wind_frequency);
	
	float displacement = wave * wind_strength * (height_factor * height_factor);

	VERTEX.x += displacement;
	VERTEX.z += displacement * 0.5;
}

// ---

uniform sampler2D albedo_texture : source_color;
uniform vec4 base_color : source_color = vec4(1.0);

void fragment() {
	vec4 tex_color = texture(albedo_texture, UV);
    ALBEDO = tex_color.rgb * base_color.rgb;
}