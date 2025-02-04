extends Node3D

@onready var timer = $Timer
@onready var tiles : Array = get_tree().get_nodes_in_group("ColoredTiles")
const MAXTILESAFE : int = 5
const MAXTILEPWUP : int = 2
const MAXTILESAFETOTAL : int = MAXTILESAFE + MAXTILEPWUP
var tileSafeCounter : int = 0

func _ready() -> void:
	timer.wait_time = 3
	_swap_tile_color()

func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	tileSafeCounter = 0
	_swap_tile_color()
	timer.start()

func _swap_tile_color() -> void:
	tiles.shuffle()
	for tile : Area3D in tiles:
		var safe = (tileSafeCounter < MAXTILESAFETOTAL) if true else false
		tile._change_tile_material(safe)
		if safe:
			tileSafeCounter += 1
			
