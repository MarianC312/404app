extends Area3D

const texture = preload("res://Blender/tile_tile.png")
var tilePower = {
	"green": {
		"material": preload("res://Materials/TileMaterials/green.tres"),
		"power": "health",
		"shift_hue": 0.5 
	},
	"gold": {
		"material": preload("res://Materials/TileMaterials/gold.tres"),
		"power": "dash",
		"shift_hue": 0.5 
	},
	"purple": {
		"material": preload("res://Materials/TileMaterials/purple.tres"),
		"power": "shield",
		"shift_hue": 0.5 
	},
	"red": {
		"material": preload("res://Materials/TileMaterials/red.tres"),
		"power": "damage",
		"shift_hue": 0.5 
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
	print(change)
	if change == true:
		_tile_power_shuffle()
		tileType = tilePowerList[0]
		# mesh.set_surface_override_material(0, tilePower[tileType]["material"])
		material.set_shader_parameter("hue_shift", 0.5)
		tileDmg = false
		cube.get_active_material(0)
	else:
		# mesh.set_surface_override_material(0, tilePower["red"]["material"])
		material.set_shader_parameter("hue_shift", 0.0)
		tileType = "red"
		tileDmg = true

func _tile_power_shuffle() -> void:
	tilePowerList.shuffle()
	while tilePowerList[0] == "red":
		tilePowerList.shuffle()

func _get_type() -> String:
	return tileType

func _print_data() -> void:
	print(name + ": " + tileType) #  + ((tileType != "red") if "(OK)" else "")
