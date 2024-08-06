@tool
extends Node3D

@onready var grid_map : GridMap = $GridMap

@export var start : bool = false : set = set_start
func set_start(val: bool) -> void:
	generate()

@export var border_size : int = 20 : set = set_border_size
func set_border_size(val: int) -> void:
	border_size = val
	if Engine.is_editor_hint():
		visualise_border()

func visualise_border():
	for i in range(-1, border_size + 1):
		grid_map.set_cell_item(Vector3i(i, 0, -1), 3)

func generate():
	print("Loading The Bloody map mate")
