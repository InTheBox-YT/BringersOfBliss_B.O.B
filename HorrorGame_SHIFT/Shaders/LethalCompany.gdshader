shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D grime_texture;
uniform vec4 tint_color : source_color = vec4(0.8, 0.7, 0.6, 1.0); // Unique color tint
uniform float grime_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.1;
uniform float flicker_speed : hint_range(0.0, 10.0) = 2.0;
uniform float cel_shade_levels : hint_range(2, 10) = 4.0; // Controls the number of shading levels
uniform float outline_thickness : hint_range(0.0, 10.0) = 1.0; // Thickness of the outline
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Outline color

void fragment() {
    // Sample the screen texture
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV).rgba;

    // Grime overlay
    vec4 grime_color = texture(grime_texture, SCREEN_UV * 2.0).rgba;
    screen_color.rgb = mix(screen_color.rgb, grime_color.rgb * tint_color.rgb, grime_intensity);

    // Noise effect
    float noise = fract(sin(dot(SCREEN_UV.xy, vec2(12.9898, 78.233))) * 43758.5453);
    screen_color.rgb = mix(screen_color.rgb, vec3(noise), noise_intensity);

    // Flicker effect
    float flicker = sin(TIME * flicker_speed) * 0.1 + 0.9;
    screen_color.rgb *= flicker;

    // Cel-shading effect
    float shade_factor = ceil(screen_color.r * cel_shade_levels) / cel_shade_levels;
    screen_color.rgb = vec3(shade_factor) * screen_color.rgb;

    // Outline effect (basic edge detection)
    vec2 offset1 = vec2(outline_thickness / 512.0, 0.0);
    vec2 offset2 = vec2(0.0, outline_thickness / 512.0);
    vec4 neighbor1 = texture(SCREEN_TEXTURE, SCREEN_UV + offset1);
    vec4 neighbor2 = texture(SCREEN_TEXTURE, SCREEN_UV - offset1);
    vec4 neighbor3 = texture(SCREEN_TEXTURE, SCREEN_UV + offset2);
    vec4 neighbor4 = texture(SCREEN_TEXTURE, SCREEN_UV - offset2);
    vec4 edge = max(abs(screen_color - neighbor1), abs(screen_color - neighbor2));
    edge = max(edge, abs(screen_color - neighbor3));
    edge = max(edge, abs(screen_color - neighbor4));
    if (dot(edge.rgb, vec3(1.0)) > 0.1) {
        screen_color.rgb = mix(screen_color.rgb, outline_color.rgb, outline_color.a);
    }

    // Final output color
    COLOR = vec4(screen_color.rgb, 1.0);
}
