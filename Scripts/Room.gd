extends CSGBox3D

@onready var tile = preload("res://Scenes/Assets/tile_01.tscn")
@onready var tileContainer : Node3D = $RoomArea/TileContainer
@onready var collShape : CollisionShape3D = $RoomArea/CollisionShape3D
var tileInstance
var tileSize : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tileInstance = tile.instantiate()
	tileSize = tileInstance.get_mesh_size()
	tileContainer.add_child(tileInstance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(name)
	print(get_shape_size())
	print(position)

func get_shape_size() -> Vector3:
	if collShape and collShape.shape:
		return collShape.shape.size
	return Vector3()
