extends Node3D

@onready var timer
@onready var tiles : Array
@onready var roomArea : Area3D = get_parent()
@onready var collShape : CollisionShape3D = roomArea.get_child(0)
@onready var currentRoom : CSGBox3D = roomArea.get_parent()
const MAXTILESAFE : int = 5
const MAXTILEPWUP : int = 2
const MAXTILESAFETOTAL : int = MAXTILESAFE + MAXTILEPWUP
var tileSafeCounter : int = 0

func _ready() -> void:
	 = roomArea.width - 2
	timer = get_child(0)
	timer.wait_time = 3
	_swap_tile_color()
	timer.connect("timeout", _on_timer_timeout)

func _process(delta: float) -> void:
	print(currentRoom.name + " is " + str(currentRoom.get_room_state()))
	print(currentRoom.name + " is " + str(currentRoom.get_room_state()))
	if currentRoom.get_room_state() == true:
		if tiles == null:
			tiles = get_children()
		if timer.is_stopped() or timer.paused:
			print("El " + currentRoom.name + " está activo, activando timer...")
			timer.connect("timeout", _on_timer_timeout)
			timer.start()
		_swap_tile_color()
	else:
		timer.stop()

func _on_timer_timeout() -> void:
	tileSafeCounter = 0
	if currentRoom.get_room_state() == true:
		_swap_tile_color()
		timer.start()

func _swap_tile_color() -> void:
	tiles.shuffle()
	for tile in tiles:
		if tile is not Timer:
			var safe = (tileSafeCounter < MAXTILESAFETOTAL) if true else false
			tile._change_tile_material(safe)
			if safe:
				tileSafeCounter += 1
			
