extends Node3D

@onready var timer
@onready var tiles : Array
@onready var roomArea : Area3D = get_parent()
@onready var collShape : CollisionShape3D = roomArea.get_child(0)
@onready var currentRoom : Node = roomArea.get_parent()
@onready var player = get_tree().get_nodes_in_group("player")
const MAXTILESAFE : int = 5
const MAXTILEPWUP : int = 2
const MAXTILESAFETOTAL : int = MAXTILESAFE + MAXTILEPWUP
var tileSafeCounter : int = 0

func _ready() -> void:
	timer = get_child(0)
	timer.wait_time = 3
	_swap_tile_color()
	timer.connect("timeout", _on_timer_timeout)

func _process(delta: float) -> void:
	if tiles.is_empty():
		tiles = get_children()
	# print(currentRoom.name + " is " + str(currentRoom.get_room_state())) # debug other rooms
	if currentRoom.get_room_state() == true:
		if timer.is_stopped() or timer.paused:
			print("El " + currentRoom.name + " está activo, activando timer...")
			timer.connect("timeout", _on_timer_timeout)
			timer.start()
	else:
		timer.stop()

func _on_timer_timeout() -> void:
	print("Soy el timer, acabo de terminar!")
	player[0]._on_timer_timeout()
	if currentRoom.get_room_state() == true:
		_swap_tile_color()
		timer.start()

func _swap_tile_color() -> void:
	tiles.shuffle()
	tileSafeCounter = 0
	# print("Soy el room " + currentRoom.name + " y estoy " + str(currentRoom.get_room_state()))
	for tile in tiles:
		if tile is not Timer:
			var safe = true if (tileSafeCounter < MAXTILESAFETOTAL) else false
			# print("Soy el tile " + tile.name + " y mi padre es " + tile.get_parent().name)
			tile._change_tile_material(safe)
			if safe:
				tileSafeCounter += 1
		else:
			print("Soy " + tile.name + " nose que soy.")

func update_position(newPosition : Vector3) -> void:
	position -= newPosition
