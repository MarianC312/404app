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
@export var dash : int = 10 # 2
@export var blendSpeed : int = 10
## The movement speed in m/s. Default is 5.
@export_range(1.0,30.0) var speed : float = 7.5
@export_range(1.0,15.0) var backwardSpeed : float = 2.5
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
const DASHSPEED : float = 14.75
const DASHDURATION : float = 1.255
const LERPSPEED : float = 2.75

# Enums
enum {IDLE, RUN, ROLL, RUNB, CROUCH, CROUCHB}

var currAnim = IDLE
var mouseMotion : Vector2 = Vector2.ZERO
var pitch : int = 0
var anim_run : float = 0.0
var anim_roll : float = 0.0
var anim_run_b : float = 0.0
var anim_crouch : float = 0.0
var anim_crouch_b : float = 0.0
var isBackward : bool = false
var isCrouch : bool = false
var currSpeed : float = 0.0 

@onready var cameraPivot : Node3D = $CameraPivot
@onready var healthBar : ProgressBar = $CameraPivot/Sprite3D/SubViewport/MarginContainer/VBoxContainer/HP
@onready var dashText : Label = $CameraPivot/Sprite3D/SubViewport/MarginContainer/VBoxContainer/DASH
@onready var scoreText : Label = $CameraPivot/Sprite3D/SubViewport/MarginContainer/VBoxContainer/SCORE
@onready var pauseMenu : Control = $CameraPivot/PauseMenu
@onready var shield0 : Area3D = $Shield0
@onready var dashTimer : Timer = $DashTimer
@onready var animTree : AnimationTree = $Body/Character/AnimationTree


func _ready() -> void:
	_ui_update("score")
	_ui_update("dash")
	healthBar.max_value = MAXHEALTH
	healthBar.value = MAXHEALTH
	health = MAXHEALTH
	cameraPivot.rotation.x = -45
	dashTimer.wait_time = DASHDURATION
	currAnim = IDLE

func _physics_process(delta : float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if isBackward:
			currSpeed = backwardSpeed
		else:
			currSpeed = speed

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
		currAnim = ROLL
		velocity.x = move_toward(velocity.x , target_velocity.x * DASHSPEED , DASHSPEED * groundAcceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z * DASHSPEED, DASHSPEED * groundAcceleration * delta)
	elif is_on_floor():
		if input_dir.is_zero_approx() and not isDashing:
			currAnim = IDLE
		else:
			if not isDashing:
				if isBackward:
					currAnim = (isCrouch) if CROUCHB else RUNB
				else:
					currAnim = (isCrouch) if CROUCH else RUN
				
		velocity.x = move_toward(velocity.x , target_velocity.x * speed , lerpf(0.0, currSpeed * groundAcceleration, LERPSPEED * delta))
		velocity.z = move_toward(velocity.z, target_velocity.z * speed, lerpf(0.0, currSpeed * groundAcceleration, LERPSPEED * delta))
	else:
		velocity.x = move_toward(velocity.x , target_velocity.x * speed , lerpf(0.0, currSpeed * groundAcceleration, LERPSPEED / 2 * delta))
		velocity.z = move_toward(velocity.z, target_velocity.z * speed, lerpf(0.0, currSpeed * groundAcceleration, LERPSPEED / 2 * delta))
	#now actually move based on velocity
	move_and_slide()
	handle_animation(delta)
	
	#rotate the player and camera pivot based on mouse movement
	rotate_y(lerpf(0.0, -mouseMotion.x * mouseSensitivity / 1000, LERPSPEED * 15 * delta))
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
	isBackward = (event.is_action_pressed("move_backward")) if true else false
	isCrouch = (event.is_action_pressed("crouch")) if true else false

func _start_dash() -> void:
	if dash > 0 and isDashing == false:
		dash -= 1
		isDashing = true
		dashTimer.start()
		_ui_update("dash")

func _on_area_3d_area_entered(area: Area3D) -> void:
	tile = area
	_add_score(tile._get_score())
	area._print_data()

func _add_score(nScore : float) -> void:
	score += nScore
	_ui_update("score")

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
	else:
		_take_damage()

func _shield_up() -> void:
	if !shield:
		shield0.show()
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
			shield0.hide()
			print("No dmg taken, shield spent!")
	else:
		free()
	tile._print_data()
	# print("player: " + str(health) + " hp")


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
		"score":
			scoreText.text = "Score: " + str(score)

func handle_animation(delta) -> void:
	match currAnim:
		IDLE:
			anim_run = lerpf(anim_run, 0, blendSpeed * delta)
			anim_roll = lerpf(anim_roll, 0, blendSpeed * delta)
			anim_run_b = lerpf(anim_run_b, 0, blendSpeed * delta)
			anim_crouch = lerpf(anim_crouch, 0, blendSpeed * delta)
			anim_crouch_b = lerpf(anim_crouch_b, 0, blendSpeed * delta)
		RUN:
			anim_run = lerpf(anim_run, 1, blendSpeed * delta)
			anim_roll = lerpf(anim_roll, 0, blendSpeed * delta)
			anim_run_b = lerpf(anim_run_b, 0, blendSpeed * delta)
			anim_crouch = lerpf(anim_crouch, 0, blendSpeed * delta)
			anim_crouch_b = lerpf(anim_crouch_b, 0, blendSpeed * delta)
		RUNB:
			anim_run = lerpf(anim_run, 0, blendSpeed * delta)
			anim_roll = lerpf(anim_roll, 0, blendSpeed * delta)
			anim_run_b = lerpf(anim_run_b, 1, blendSpeed * delta)
			anim_crouch = lerpf(anim_crouch, 0, blendSpeed * delta)
			anim_crouch_b = lerpf(anim_crouch_b, 0, blendSpeed * delta)
		ROLL:
			anim_run = lerpf(anim_run, 0, blendSpeed * delta)
			anim_roll = lerpf(anim_roll, 1, blendSpeed * delta)
			anim_run_b = lerpf(anim_run_b, 0, blendSpeed * delta)
			anim_crouch = lerpf(anim_crouch, 0, blendSpeed * delta)
			anim_crouch_b = lerpf(anim_crouch_b, 0, blendSpeed * delta)
		CROUCH:
			anim_run = lerpf(anim_run, 0, blendSpeed * delta)
			anim_roll = lerpf(anim_roll, 0, blendSpeed * delta)
			anim_run_b = lerpf(anim_run_b, 0, blendSpeed * delta)
			anim_crouch = lerpf(anim_crouch, 1, blendSpeed * delta)
			anim_crouch_b = lerpf(anim_crouch_b, 0, blendSpeed * delta)
		CROUCHB:
			anim_run = lerpf(anim_run, 0, blendSpeed * delta)
			anim_roll = lerpf(anim_roll, 0, blendSpeed * delta)
			anim_run_b = lerpf(anim_run_b, 0, blendSpeed * delta)
			anim_crouch = lerpf(anim_crouch, 0, blendSpeed * delta)
			anim_crouch_b = lerpf(anim_crouch_b, 1, blendSpeed * delta)
		_:
			print("Animación inexistente")
	update_tree()

func update_tree() -> void:
	if currAnim != ROLL:
		anim_roll = 0.0
	animTree.set("parameters/Run/blend_amount", anim_run)
	animTree.set("parameters/Roll/blend_amount", anim_roll)
	animTree.set("parameters/RunB/blend_amount", anim_run_b)
	animTree.set("parameters/Crouch/blend_amount", anim_crouch)
	animTree.set("parameters/CrouchB/blend_amount", anim_crouch_b)

func _end_dash() -> void:
	isDashing = false

func _on_dash_timer_timeout() -> void:
	_end_dash()
