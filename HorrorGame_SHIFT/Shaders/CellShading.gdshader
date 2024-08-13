shader_type canvas_item;
render_mode unshaded;

uniform vec4 level1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 level2 : source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform vec4 level3 : source_color = vec4(0.4, 0.4, 0.4, 1.0);
uniform vec4 level4 : source_color = vec4(0.6, 0.6, 0.6, 1.0);
uniform vec4 level5 : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform vec4 level6 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 level7 : source_color = vec4(1.0, 0.5, 0.5, 1.0);
uniform vec4 level8 : source_color = vec4(0.5, 0.5, 1.0, 1.0);
uniform vec4 level9 : source_color = vec4(0.5, 1.0, 0.5, 1.0);

uniform float threshold1 	: hint_range(0.0,1.0) = .1;
uniform float threshold2 	: hint_range(0.0,1.0) = .2;
uniform float threshold3	: hint_range(0.0,1.0) = .3;
uniform float threshold4    : hint_range(0.0,1.0) = .4;
uniform float threshold5    : hint_range(0.0,1.0) = .5;
uniform float threshold6    : hint_range(0.0,1.0) = .6;
uniform float threshold7    : hint_range(0.0,1.0) = .7;
uniform float threshold8    : hint_range(0.0,1.0) = .8;
uniform float threshold9    : hint_range(0.0,1.0) = .9;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float contrast : hint_range(0.5, 2.0) = 1.2;
uniform float saturation : hint_range(0.0, 2.0) = 0.8;

void fragment() {
    // Sample the screen texture
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV).rgba;
	
    // Calculate average brightness
	float rgb_avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;

    // Apply posterization based on thresholds
	if (rgb_avg < threshold1) {
		COLOR = level1.rgba;
	} else if (rgb_avg < threshold2) {
		COLOR = level2.rgba;
	} else if (rgb_avg < threshold3) {
		COLOR = level3.rgba;
	} else if (rgb_avg < threshold4) {
		COLOR = level4.rgba;
	} else if (rgb_avg < threshold5) {
		COLOR = level5.rgba;
	} else if (rgb_avg < threshold6) {
		COLOR = level6.rgba;
	} else if (rgb_avg < threshold7) {
		COLOR = level7.rgba;
	} else if (rgb_avg < threshold8) {
		COLOR = level8.rgba;
	} else if (rgb_avg < threshold9) {
		COLOR = level9.rgba;
	} else {
		COLOR = level9.rgba; // Adjust the final level as needed
	}

    // Adjust contrast
	COLOR.rgb = (COLOR.rgb - 0.5) * contrast + 0.5;
	
    // Adjust saturation
	float gray = dot(COLOR.rgb, vec3(0.3, 0.59, 0.11));
	COLOR.rgb = mix(vec3(gray), COLOR.rgb, saturation);
}
