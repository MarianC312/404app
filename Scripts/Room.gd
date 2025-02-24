extends CSGBox3D

@onready var tile = preload("res://Scenes/Assets/tile_01.tscn")
@onready var tileContainer : Node3D = $RoomArea/TileContainer
var tileInstance
var tileSize : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tileInstance = tile.instantiate()
	tileSize = tileInstance.get_mesh_size()
	tileContainer.add_child(tileInstance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(position.x)
	print(position.y)
	print(position.z)
