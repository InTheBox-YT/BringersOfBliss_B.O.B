extends Node3D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var player = preload("res://Scenes/Player.tscn")

var playerInstance = Player.instantiate()
#var shader = playerInstance.get_node("$CanvasLayer/TextureRect")
#var camera = playerInstance.get_node("$Camera3D")
const Player = preload("res://Scenes/Player.tscn")
#var PlayerUI_instance = PlayerUI.instance()

func _unhandled_input(event):
	if Input.is_action_just_pressed("Pause"):
		pause_menu.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_quit_button_pressed():
	get_tree().quit()

func _on_host_button_pressed():
	main_menu.hide()
	pause_menu.hide()
	add_player(multiplayer.get_unique_id())

func _on_join_button_pressed():
	main_menu.hide()
	

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))

func _on_back_button_pressed():
	pause_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#$"%Head/Camera3D/PlayerUI".add_child(PlayerUI_instance)
	#PlayerUI_instance.hide()
	
