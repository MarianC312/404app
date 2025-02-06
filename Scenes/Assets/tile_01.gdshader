shader_type spatial;
render_mode unshaded;

uniform vec3 base_color : source_color = vec3(0.32, 0.8, 0.86); // Color base verde
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.0; // Intensidad del brillo
uniform float glow_speed : hint_range(0.0, 10.0) = 5.0; // Velocidad del brillo
uniform float hue_shift : hint_range(0.0, 1.0); // 0 to 1 range
uniform sampler2D albedo_texture;

// Function to convert RGB to HSV
vec3 rgb_to_hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// Function to convert HSV back to RGB
vec3 hsv_to_rgb(vec3 c) {
    vec3 p = abs(fract(c.xxx + vec3(0.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0);
    return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}


void vertex() {
	// Called for every vertex the material is visible on.
	// VERTEX.y += abs(sin(TIME));
}

void fragment() {
	//// Color base
    //vec3 color = base_color;
//
    //// Efecto de brillo dinámico usando una función seno
    //float glow = sin(TIME * glow_speed) * 0.5 + 0.5; // Oscila entre 0 y 1
    //color += color * glow * glow_intensity; // Añade el brillo al color base
//
    //// Aplicar el color final
    //ALBEDO = color;
	//ROUGHNESS = 0.2;
	//EMISSION = color * glow_intensity; // Hace que el objeto emita luz

	// ===== //

	vec4 albedo_color = texture(albedo_texture, UV);
    vec3 hsv = rgb_to_hsv(albedo_color.rgb);
    hsv.x = mod(hsv.x + hue_shift, 1.0); // Shift hue
    vec3 new_rgb = hsv_to_rgb(hsv);

    ALBEDO = new_rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
