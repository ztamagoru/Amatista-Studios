shader_type spatial;

uniform sampler2D texture_a;
uniform sampler2D texture_b;
uniform float blend : hint_range(0.0, 1.25);

void fragment() {
	vec4 col_a = texture(texture_a, UV);
	vec4 col_b = texture(texture_b, UV);
	
	ALBEDO = mix(col_a.rgb, col_b.rgb, blend);
}
