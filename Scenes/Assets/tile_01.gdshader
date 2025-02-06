shader_type spatial;

uniform vec3 base_color : source_color = vec3(0.32, 0.8, 0.86); // Color base verde
uniform float glow_intensity : hint_range(0.0, 5.0) = 1.0; // Intensidad del brillo
uniform float glow_speed : hint_range(0.0, 10.0) = 5.0; // Velocidad del brillo

void vertex() {
	// Called for every vertex the material is visible on.
	// VERTEX.y += abs(sin(TIME));
}

void fragment() {
	// Color base
    vec3 color = base_color;

    // Efecto de brillo dinámico usando una función seno
    float glow = sin(TIME * glow_speed) * 0.5 + 0.5; // Oscila entre 0 y 1
    color += color * glow * glow_intensity; // Añade el brillo al color base

    // Aplicar el color final
    ALBEDO = color;
	ROUGHNESS = 0.2;
	EMISSION = color * glow_intensity; // Hace que el objeto emita luz
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
