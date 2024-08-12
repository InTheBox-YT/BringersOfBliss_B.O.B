extends RigidBody3D

# Exported variables for easy drag-and-drop in the editor
@export var player: NodePath
@export var walls: Array[NodePath]
@export var detection_range: float = 20.0
@export var attack_range: float = 2.0
@export var hide_spots: Array[NodePath]

var player_ref: Node3D
var navigation: NavigationAgent3D
var current_target: Vector3
var is_hiding: bool = false
var is_attacking: bool = false

# Ensuring the AI doesn't tip over
var upright_force: float = 10.0

func _ready():
	player_ref = get_node(player)
	navigation = NavigationAgent3D.new()
	add_child(navigation)
	navigation.agent_radius = 1.0
	navigation.agent_height = 2.0
	navigation.pathfinding_map = get_world_3d().get_navigation_map()
	set_target(player_ref.global_transform.origin)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	# Keep the AI upright
	var up_direction = transform.basis.get_axis(1) # Y axis
	var upright_torque = up_direction.cross(Vector3.UP) * upright_force
	apply_torque_impulse(upright_torque)

	# Handle movement
	if not is_attacking:
		_check_for_player()
		_navigate_to_target(state)
		_check_for_attack()
	if is_hiding:
		_find_hide_spot()

func _check_for_player():
	if player_ref and global_transform.origin.distance_to(player_ref.global_transform.origin) < detection_range:
		if _can_see_player():
			is_hiding = false
			set_target(player_ref.global_transform.origin)
		else:
			is_hiding = true

func _can_see_player() -> bool:
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(global_transform.origin, player_ref.global_transform.origin, [self] + walls)
	return result.empty()

func _navigate_to_target(state: PhysicsDirectBodyState3D):
	if not navigation.is_path_computed():
		return
	if navigation.get_remaining_path().size() > 0:
		var direction = (navigation.get_next_path_position() - global_transform.origin).normalized()
		var movement_impulse = direction * 50.0 # AI speed
		apply_impulse(Vector3.ZERO, movement_impulse)

func _check_for_attack():
	if player_ref and global_transform.origin.distance_to(player_ref.global_transform.origin) < attack_range:
		is_attacking = true
		_attack_player()

func _attack_player():
	print("Attacking Player!")
	# Implement your attack logic here

func _find_hide_spot():
	if hide_spots.size() == 0:
		return
	var nearest_hide_spot = hide_spots[0].global_transform.origin
	var min_distance = global_transform.origin.distance_to(nearest_hide_spot)
	for spot in hide_spots:
		var distance = global_transform.origin.distance_to(spot.global_transform.origin)
		if distance < min_distance:
			nearest_hide_spot = spot.global_transform.origin
			min_distance = distance
	set_target(nearest_hide_spot)

func set_target(target: Vector3):
	navigation.set_target_location(target)
