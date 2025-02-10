extends CharacterBody3D

@export_category("Configuration")
## Mouse sensitivity for looking around. Default is 3.0
@export_range(1.0,5.0) var mouseSensitivity = 3.0
## The amount of acceleration on the ground- less feels floaty, more is snappy-[br]Default is 4
@export_range(1.0,10.0) var groundAcceleration := 4.0
## the amount of acceleration when in the air. less feels more floaty more is more snappy.[br]Default is 0.5
@export_range(0.0,5.0) var airAcceleration := 0.5
## Get the gravity from the project settings to be synced with RigidBody nodes.
@export_range(5.0,25.0) var gravity : float = 15.0

# Vars
@export_category("Statistics")
## Player health, configurated by MAXHEALTH const at _ready().
@export var health : int
## Score won by player in match.
@export var score : int = 0
## Available hability for player. Applies a force to body in looking direction
@export var dash : int = 0
## The movement speed in m/s. Default is 5.
@export_range(1.0,30.0) var speed : float = 5.0
## The Jump Velocity in m/s- default to 6.0
@export_range(2.0,10.0) var jumpVelocity : float = 6.0

@export_category("Procs")
## Tile where player is standing
var tile : Area3D
## Game paused menu controller
var gamePaused : bool = false
## Dash controller
var isDashing : bool = false
## Available hability for player. Prevents damage when true.
@export var shield : bool = false

# Const
const MAXHEALTH : int = 10
const MAXDASH : int = 2
const MAXSHIELD : int = 1
const DASHSPEED : float = 18.5
const DASHDURATION : float = 0.025

var mouseMotion : Vector2 = Vector2.ZERO
var pitch : int = 0

@onready var cameraPivot : Node3D = $CameraPivot
@onready var healthBar : ProgressBar = $CameraPivot/Sprite3D/SubViewport/MarginContainer/VBoxContainer/HP
@onready var dashText : Label = $CameraPivot/Sprite3D/SubViewport/MarginContainer/VBoxContainer/DASH
@onready var scoreText : Label = $CameraPivot/Sprite3D/SubViewport/MarginContainer/VBoxContainer/SCORE
@onready var pauseMenu : Control = $CameraPivot/PauseMenu
@onready var dashTimer : Timer = $DashTimer


func _ready() -> void:
	healthBar.max_value = MAXHEALTH
	healthBar.value = MAXHEALTH
	health = MAXHEALTH
	cameraPivot.rotation.x = -45
	dashTimer.wait_time = DASHDURATION

func _physics_process(delta : float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	var target_velocity := Vector3.ZERO
	if direction:
		target_velocity = direction
	#now apply velocity with lerp based on whether on ground or in air
	if isDashing:
		velocity = transform.basis.z * -DASHSPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x , target_velocity.x * speed , speed * groundAcceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z * speed, speed * groundAcceleration * delta)
	else:
		velocity.x = move_toward(velocity.x , target_velocity.x * speed , speed * airAcceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z * speed, speed * airAcceleration * delta)
	#now actually move based on velocity
	move_and_slide()
	
	#rotate the player and camera pivot based on mouse movement
	rotate_y(-mouseMotion.x * mouseSensitivity / 1000)
	pitch -= mouseMotion.y * mouseSensitivity / 1000
	pitch = clampf(pitch,-1.35,1.35)
	# cameraPivot.rotation.x = pitch
	#reset it
	mouseMotion = Vector2.ZERO

#handle and store mouse motion
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		mouseMotion = event.relative
	if event.is_action_pressed("scape"):
		_pause_menu()
	if event.is_action_pressed("sprint"):
		_start_dash()

func _start_dash() -> void:
	if dash > 0:
		dash -= 1
		isDashing = true
		dashTimer.start()
		_ui_update("dash")

func _on_area_3d_area_entered(area: Area3D) -> void:
	tile = area
	area._print_data()

func _on_timer_timeout() -> void:
	if tile != null:
		match tile._get_type():
			"red": # prueba de repo git funcando
				_take_damage()
			"green":
				_heal_up()
			"gold":
				_dash_up()
			"purple":
				_shield_up()

func _shield_up() -> void:
	if !shield:
		shield = true

func _dash_up() -> void:
	if dash < MAXDASH:
		dash += 1
	_ui_update("dash")

func _heal_up() -> void:
	health += 1
	_ui_update("hp")

func _take_damage() -> void:
	if health > 0:
		if !shield:
			health -= 1
			_ui_update("hp")
		else:
			shield = false
			print("No dmg taken, shield spent!")
	else:
		free()
	tile._print_data()
	print("player: " + str(health) + " hp")


func _on_timer_ready() -> void:
	pass # Replace with function body.

func _pause_menu() -> void:
	if gamePaused:
		pauseMenu.hide()
		Engine.time_scale = 1
	else:
		pauseMenu.show()
		Engine.time_scale = 0
	gamePaused = !gamePaused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if gamePaused else Input.MOUSE_MODE_CAPTURED
	
func _ui_update(type : String) -> void:
	match type:
		"dash":
			dashText.text = "Dash: " + str(dash)
		"hp":
			healthBar.value = health

func _end_dash() -> void:
	isDashing = false

func _on_dash_timer_timeout() -> void:
	_end_dash()
