extends Camera3D

@export var mouse_sensitivity: float = 0.1
@export var move_speed: float = 5.0

var _yaw: float = 0.0
var _pitch: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta: float):
	_process_input(delta)
	_update_rotation()

func _process_input(delta: float):
	var input = Vector3()

	if Input.is_action_pressed("W"):  # W key
		input.z -= 1
	if Input.is_action_pressed("S"):  # S key
		input.z += 1
	if Input.is_action_pressed("A"):  # A key
		input.x -= 1
	if Input.is_action_pressed("D"):  # D key
		input.x += 1
	if Input.is_action_pressed("ui_page_up"):  # E key
		input.y += 1
	if Input.is_action_pressed("ui_page_down"):  # Q key
		input.y -= 1

	input = input.normalized()
	var transform = global_transform
	transform.origin += (transform.basis.z * input.z * move_speed * delta)
	transform.origin += (transform.basis.x * input.x * move_speed * delta)
	transform.origin += (transform.basis.y * input.y * move_speed * delta)
	global_transform = transform

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_yaw -= event.relative.x * mouse_sensitivity
		_pitch -= event.relative.y * mouse_sensitivity
		_pitch = clamp(_pitch, -89, 89)

func _update_rotation():
	rotation_degrees = Vector3(_pitch, _yaw, 0)
