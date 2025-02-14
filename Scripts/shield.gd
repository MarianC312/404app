extends Area3D

const ROTATIONSPEED : float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotate around the X axis
	rotate_x(ROTATIONSPEED * delta)

	# Rotate around the Z axis
	rotate_z(ROTATIONSPEED * delta)

	# Rotate around the Z axis
	rotate_y(ROTATIONSPEED * delta)
