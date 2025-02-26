extends Area3D

const texture = preload("res://Blender/tile_tile.png")
var tilePower = {
	"green": {
		"material": preload("res://Materials/TileMaterials/green.tres"),
		"power": "health",
		"shift_hue": 0.5,
		"score": 2.0
	},
	"gold": {
		"material": preload("res://Materials/TileMaterials/gold.tres"),
		"power": "dash",
		"shift_hue": 0.325,
		"score": 5.0
	},
	"purple": {
		"material": preload("res://Materials/TileMaterials/purple.tres"),
		"power": "shield",
		"shift_hue": 1.0,
		"score": 5.0
	},
	"red": {
		"material": preload("res://Materials/TileMaterials/red.tres"),
		"power": "damage",
		"shift_hue": 0.185,
		"score": 1.0
	}
}
var tilePowerList : Array
# const shader = preload("res://Scenes/Assets/tile_01.gdshader")

var noise : FastNoiseLite = FastNoiseLite.new()
var noiseSeed: int

@onready var cube : MeshInstance3D = $tile/Cube
var tileType : String = ""
var tileDmg : bool = false
var material

func _ready() -> void:
	tilePowerList = tilePower.keys()
	material = cube.get_surface_override_material(0)
	material.set_shader_parameter("albedo_texture", texture)
	material.set_shader_parameter("hue_shift", randf_range(-1.0, 1.0))

func _change_tile_material(change: bool) -> void:
	if change == true:
		_tile_power_shuffle()
		var tileTypeBack = tileType
		tileType = tilePowerList[0]
		if tileType != tileTypeBack:
			# mesh.set_surface_override_material(0, tilePower[tileType]["material"])
			material.set_shader_parameter("hue_shift", tilePower[tileType]["shift_hue"])
			tileDmg = false
	else:
		if tileType != "red":
			# mesh.set_surface_override_material(0, tilePower["red"]["material"])
			material.set_shader_parameter("hue_shift", tilePower["red"]["shift_hue"])
			tileType = "red"
			tileDmg = true

func _tile_power_shuffle() -> void:
	tilePowerList.shuffle()
	while tilePowerList[0] == "red":
		tilePowerList.shuffle()

func _get_type() -> String:
	return tileType

func _get_score() -> float:
	return tilePower[tileType]["score"]

func _print_data() -> void:
	# print(name + ": " + tileType) #  + ((tileType != "red") if "(OK)" else "")
	pass

func get_mesh_size() -> Vector3:
	#if cube.mesh:
		#return cube.mesh.get_aabb().size
	return Vector3()
