extends CSGBox3D

@export var nextLevel = "res://Scenes/Assets/Levels/lv_room_01.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_next_level() -> String:
	return nextLevel
