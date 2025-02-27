@tool
extends CSGBox3D

@onready var tile = preload("res://Scenes/Assets/tile_01.tscn")
@onready var tileContainer : Node3D = $RoomArea/TileContainer
@onready var collShape : CollisionShape3D = $RoomArea/CollisionShape3D
@export var matrix : Vector2 = Vector2(5,5)
var loadedMatrix : Vector2 = Vector2(0,0)
var tileInstance
var tileSize : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, matrix.x, 1):
		for j in range(0, matrix.y, 1):
			tileInstance = tile.instantiate()
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
		print("Cargando tile en: " + str(loadedMatrix))
		child.position = Vector3(loadedMatrix.x,0,loadedMatrix.y)
		loadedMatrix.x += 2
		if loadedMatrix.x >= matrix.x * 2:
			loadedMatrix.x = 0
			loadedMatrix.y += 2
