extends Node3D

@onready var player = $Player
@onready var timer = $TestRoom/TileContainer/Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = 4.0
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.health <= 0:
		get_tree().change_scene_to_file("res://Scenes/Menues/Death/DeathMenu.tscn")
