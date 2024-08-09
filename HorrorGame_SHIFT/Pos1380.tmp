shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

// palette that will be displayed on the screen
uniform sampler2D palette: repeat_disable, filter_nearest;

// original palette
uniform sampler2D origPalette: repeat_disable, filter_nearest;

// number of colors in palettes, horizontally and vertically.
uniform ivec2 paletteSize;

void fragment() {
	vec4 screenColor = COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 uvOffset = 1.0/vec2(paletteSize);
	
	for (int x = 0; x < paletteSize.x; x++)
	for (int y = 0; y < paletteSize.y; y++) {
		vec2 paleteUV = vec2(float(x) + 0.5, float(y) + 0.5) * uvOffset;
		
		vec4 oldColor = texture(origPalette, paleteUV);
		vec4 newColor = texture(palette, paleteUV);

		float areSameColor = step(distance(screenColor, oldColor), 0.0);
		
		COLOR = mix(COLOR, newColor, areSameColor);
	}
}