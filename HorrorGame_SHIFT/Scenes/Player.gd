extends CharacterBody3D

# Player Variables
var curSpeed
const WALK_SPEED = 5.0
const RUN_SPEED = 8.0

const MAX_STAMINA = 5.0
var Stamina = MAX_STAMINA

const JUMP_VELOCITY = 4.5
var SENSITIVITY = 0.003

# View Bobbing
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# FOV
var target_fov
const BASE_FOV = 70.0
const ZOOMED_FOV = 30.0
const ZOOM_SPEED = 5.0
const FOV_CHANGE = 1.50

# Gravity
var gravity = 9.8

# create variables referencing objects
@onready var head = $Head
@onready var camera = $Head/Camera3D

# Calls on First Frame
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle Sprinting
	if Input.is_action_pressed("Run") and is_on_floor():
		Stamina -= delta;
		if Stamina >= 0:
			curSpeed = RUN_SPEED
		else:
			curSpeed = WALK_SPEED
	else:
		if Stamina <= MAX_STAMINA:
			Stamina += delta
		curSpeed = WALK_SPEED

	# Movement
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (head.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * curSpeed
			velocity.z = direction.z * curSpeed
		else:
			velocity.x = 0
			velocity.z = 0
	else:
		velocity.x = lerp(velocity.x, direction.x * curSpeed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * curSpeed, delta * 2.0)
	
	# Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# Handle FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, RUN_SPEED * 2)
	if Input.is_action_pressed("Zoom"):
		target_fov = ZOOMED_FOV
	else:
		target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP 
	return pos
