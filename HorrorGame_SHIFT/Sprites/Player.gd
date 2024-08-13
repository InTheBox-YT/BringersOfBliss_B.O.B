extends CharacterBody3D
@onready var camera = $Camera3D

# Base Variables
# I WANNA KILL MYSLEF
const WALK_SPEED = 6.0
const RUN_SPEED = 8.0
const CROUCH_SPEED = 3.0
var STAMINA = 20

const JUMP_VELOCITY = 5.0
const GRAVITY = 25.0

var curspeed = WALK_SPEED
var normal_fov = 70.0
var zoomed_fov = 30.0
var zoom_speed = 5.0
var target_fov = normal_fov



func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true
	camera.fov = normal_fov

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .002)
		camera.rotate_x(-event.relative.y * .002)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2) 
	if Input.is_action_just_pressed("quit"):
		camera.current = false
		#WORK GOD DAMMIT
		

func _physics_process(delta):
	print(STAMINA)
	
	if not is_multiplayer_authority(): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Adds Running
	if Input.is_action_pressed("Run") and is_on_floor():
		STAMINA -= delta;
		if STAMINA >= 0:
			curspeed = RUN_SPEED
		else:
			curspeed = WALK_SPEED
	else:
		if STAMINA <= 20:
			STAMINA += delta
		else:
			pass
		curspeed = WALK_SPEED
	
	# Handle movement.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * curspeed
		velocity.z = direction.z * curspeed
	else:
		velocity.x = move_toward(velocity.x, 0, curspeed)
		velocity.z = move_toward(velocity.z, 0, curspeed)

	move_and_slide()

	# Handle zoom.
	if Input.is_action_pressed("Zoom"):
		target_fov = zoomed_fov
	else:
		target_fov = normal_fov
	
	camera.fov = lerp(camera.fov, target_fov, zoom_speed * delta)

func _on_back_button_pressed():
	camera.current = true
