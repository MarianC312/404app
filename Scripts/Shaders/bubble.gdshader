shader_type spatial;

// Uniforms for customization
uniform float refraction_strength : hint_range(0, 1) = 0.1;
uniform float iridescence_strength : hint_range(0, 1) = 0.5;
uniform float bubble_thickness : hint_range(0, 1) = 0.2;
uniform vec4 bubble_color  = vec4(0.8, 0.9, 1.0, 0.5);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Function to calculate iridescence
vec3 calculate_iridescence(float angle) {
    return vec3(
        0.5 + 0.5 * cos(angle + 0.0),
        0.5 + 0.5 * cos(angle + 2.0),
        0.5 + 0.5 * cos(angle + 4.0)
    );
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Calculate the normal in world space
	vec3 world_normal = normalize(NORMAL);

	// Calculate the view direction
	vec3 view_dir = normalize(-VERTEX);

	// Fresnel effect for transparency
	float fresnel = dot(view_dir, world_normal);
	fresnel = pow(1.0 - fresnel, 2.0);

	// Refraction effect
	vec3 refracted = refract(view_dir, world_normal, refraction_strength);
	vec3 refracted_color = textureLod(SCREEN_TEXTURE, SCREEN_UV + refracted.xy * 0.1, 0.0).rgb;

	// Iridescence effect
	float iridescence_angle = dot(world_normal, view_dir) * 10.0;
	vec3 iridescence_color = calculate_iridescence(iridescence_angle) * iridescence_strength;

	// Combine effects
	vec3 final_color = mix(refracted_color, bubble_color.rgb, bubble_thickness);
	final_color += iridescence_color;

	// Set the output color
	ALBEDO = final_color;
	ALPHA = bubble_color.a * fresnel;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
