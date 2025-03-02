#@tool
extends CSGCylinder3D

@onready var tile = preload("res://Scenes/Assets/tile_01.tscn")
@onready var tileContainer : Node3D = $RoomArea/TileContainer
@onready var collShape : CollisionShape3D = $RoomArea/CollisionShape3D
@export var matrix : Vector2 = Vector2(5,5)
@onready var player = $"../../../Player"
var roomActive : bool = false
var loadedMatrix : Vector2 = Vector2(0,0)
var tileInstance
var tileSize : Vector3
var newPos : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collShape.shape.set_height(height * 2)
	matrix.x = height * 2.75
	matrix.y = height * 2.75
	#print("Data of " + name + ":")
	#print("size: " + str(size))
	#print("collShape size" + str(collShape.shape.size))
	#print(get_child(0).name + ": pos = " + str(get_child(0).position))
	#print(str(size.x) + " - " + str(size.z) + " = " + str(size.x - size.z))
	#if (size.x - size.z) == 0:
			#newPos = Vector3(abs(size.x) * -0.5, 0, abs(size.z) * -0.5)
	#else:
		#if size.x > size.z:
			#newPos = Vector3(abs(size.x) * -0.5, 0, abs(size.z) * -0.5)
		#else:
			#newPos = Vector3(abs(size.x) * -0.5, 0, abs(size.z) * -0.5)
	newPos = Vector3((abs(height * 2.75) * -0.5) + 0.5, 0, (abs(height * 2.75) * -0.5) + 0.5)
	#newPos = Vector3.ZERO
	print(get_child(0).name + ": pos = " + str(newPos))
	print(newPos)
	# get_child(0).position += newPos
	tileContainer.update_position(newPos)
	for i in range(0, matrix.x, 1):
		for j in range(0, matrix.y, 1):
			tileInstance = tile.instantiate()
			tileInstance.add_to_group("ColoredTiles")
			# tileSize = tileInstance.get_mesh_size()
			tileContainer.add_child(tileInstance)
	_load_floor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_shape_size() -> Vector3:
	if collShape and collShape.shape:
		return collShape.shape.size
	return Vector3()

func _load_floor() -> void:
	var tileChilds = tileContainer.get_children()
	for child in tileChilds:
		if child is not Timer:
			# print("Cargando tile en: " + str(loadedMatrix))
			child.position = Vector3(loadedMatrix.x,0,loadedMatrix.y)
			loadedMatrix.x -= 1
			if abs(loadedMatrix.x) >= matrix.x:
				loadedMatrix.x = 0
				loadedMatrix.y -= 1

func change_room_state() -> void:
	print("Changing room state from " + str(roomActive) + " to " + str(!roomActive))
	roomActive = !roomActive
	if roomActive:
		swap_tile_color()

func get_room_state() -> bool:
	return roomActive

func swap_tile_color() -> void:
	tileContainer._swap_tile_color()
