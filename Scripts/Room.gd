#@tool
extends CSGBox3D

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
	print(str(size.x) + " - " + str(size.z) + " = " + str(size.x - size.z))
	if (size.x - size.z) == 0:
			newPos = Vector3(-1, 0, 0)
	else:
		if size.x > size.z:
			newPos = Vector3(((size.x - (12 + 0)) / 2), 0, 0)
		else:
			newPos = Vector3(((size.x - (12 + 0)) / 2), 0, 0)
	print(newPos)
	get_child(0).position += newPos
	tileContainer.update_position(Vector3(0, 0, 0))
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
			child.position = Vector3(((collShape.shape.size.x - 2) / 2) + loadedMatrix.x,0,loadedMatrix.y)
			loadedMatrix.x += 2
			if loadedMatrix.x >= matrix.x * 2:
				loadedMatrix.x = 0
				loadedMatrix.y += 2

func change_room_state() -> void:
	print("Changing room state from " + str(roomActive) + " to " + str(!roomActive))
	roomActive = !roomActive

func get_room_state() -> bool:
	return roomActive
