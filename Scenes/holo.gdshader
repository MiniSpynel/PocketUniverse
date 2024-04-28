shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0.0, 0.5, 1.0);
	ALPHA = 0.5;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
