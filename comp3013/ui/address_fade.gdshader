shader_type canvas_item;

uniform float rect_width_pixels;
uniform float fade_width_pixels = 100.0;
uniform float fade_strength: hint_range(0.0, 1.0) = 0.5;

void fragment() {
	float pixel_x = UV.x * rect_width_pixels;
	
	float fade = smoothstep(0.0, fade_width_pixels, pixel_x);
	float noise = fract(sin(dot(UV.xy, vec2(12.9898, 78.233))) * 43758.5433);
	fade += (noise - 0.5) * 0.02;
	fade = clamp(fade, 0.0, 1.0);
	
	COLOR = vec4(0.0, 0.0, 0.0, fade * fade_strength);
}