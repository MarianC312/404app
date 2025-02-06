extends Area3D

var tilePower = {
	"green": {
		"material": preload("res://Materials/TileMaterials/green.tres"),
		"power": "health"
	},
	"gold": {
		"material": preload("res://Materials/TileMaterials/gold.tres"),
		"power": "dash"
	},
	"purple": {
		"material": preload("res://Materials/TileMaterials/purple.tres"),
		"power": "shield"
	},
	"red": {
		"material": preload("res://Materials/TileMaterials/red.tres"),
		"power": "damage"
	}
}
var tilePowerList : Array
# const shader = preload("res://Scenes/Assets/tile_01.gdshader")

@onready var mesh : MeshInstance3D = $MeshInstance3D
var tileType : String = ""
var tileDmg : bool = false

func _ready() -> void:
	tilePowerList = tilePower.keys()

func _change_tile_material(change: bool) -> void:
	if change == true:
		_tile_power_shuffle()
		tileType = tilePowerList[0]
		# mesh.set_surface_override_material(0, tilePower[tileType]["material"])
		tileDmg = false
	else:
		mesh.set_surface_override_material(0, tilePower["red"]["material"])
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
