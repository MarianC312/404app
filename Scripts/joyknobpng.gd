extends Sprite2D

@onready var joystick: Node2D = $".."

var pressing : bool = false
@export var maxLength : int = 50
@export var deadZone : int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxLength *= joystick.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pressing:
		var mouse_gpos = get_global_mouse_position()
		if mouse_gpos.distance_to(joystick.global_position) <= maxLength:
			global_position = mouse_gpos
		else:
			var angle = joystick.global_position.angle_to_point(mouse_gpos)
			global_position.x = joystick.global_position.x + cos(angle) * maxLength
			global_position.y = joystick.global_position.y + sin(angle) * maxLength
		calculate_vector()
	else:
		global_position = lerp(global_position, joystick.global_position, delta * 30)
		joystick.posVector = Vector2.ZERO

func calculate_vector() -> void:
	if abs(global_position.x - joystick.global_position.x) >= deadZone:
		joystick.posVector.x = (global_position.x - joystick.global_position.x) / maxLength
		joystick.posVector.y = (global_position.y - joystick.global_position.y) / maxLength

func _on_button_button_down() -> void:
	pressing = true


func _on_button_button_up() -> void:
	pressing = false
