shader_type spatial;

// Uniforms for customization
uniform sampler2D noise_texture : source_color;
uniform float noise_scale : hint_range(0.1, 10.0) = 1.0;
uniform float smoke_density : hint_range(0.1, 5.0) = 1.0;
uniform vec4 smoke_color : source_color = vec4(0.8, 0.8, 0.8, 0.5);
uniform float time_scale : hint_range(0.1, 10.0) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Sample the noise texture with scrolling UVs
	vec2 uv = UV * noise_scale;
	uv.y += TIME * time_scale; // Animate the smoke upwards
	float noise_value = texture(noise_texture, uv).r;

	// Use the noise value to create smoke density
	float density = smoothstep(0.2, 0.8, noise_value) * smoke_density;

	// Apply smoke color and transparency
	vec3 final_color = smoke_color.rgb * density;
	float alpha = smoke_color.a * density;

	// Set the output color
	ALBEDO = final_color;
	ALPHA = alpha;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
