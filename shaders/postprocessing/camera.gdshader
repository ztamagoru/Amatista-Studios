shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear;
uniform float brightness : hint_range(0.5, 1.5) = 1.0;

void fragment() {
    vec4 screen_color = texture(screen_texture, SCREEN_UV);

    vec3 color = screen_color.rgb * brightness;

    COLOR = vec4(clamp(color, vec3(0.0), vec3(1.0)), screen_color.a);
}