extends Node


signal change_scene (scene)


#region Variables

#exports variables
export var turn: String = "red"


#scene objects
onready var obj_Setting_menu: Control = $Canvas_layer_100/Setting_menu
onready var obj_main_camera: Camera2D = $Main_camera
onready var obj_minimap: Control = $Canvas_layer_5/Minimap
onready var obj_action_bar: Control = $Canvas_layer_5/Action_bar
onready var obj_console: Control = $Canvas_layer_5/Console

onready var obj_map: Node2D = $Map
onready var obj_player_buffer: Node = $Players

onready var obj_setting_menu: Control = $Canvas_layer_100/Setting_menu


#others
var teams: Dictionary = {"red": [], "blue": [], "green": [], "yellow": []}

var personal_player: Node
var selection: Node


var mouse_pos: Vector2
var hex_mouse_pos: Vector3
var last_mouse_pos := Vector2()
var last_hex_mouse_pos := Vector3()

#unused variable
var _unused


#endregion


func _ready() -> void:
	print("got there 0")

	prepare_game()

	return



func _process(_delta) -> void:
	if Input.is_action_just_pressed("camera_reset"):
		selection = personal_player

	if Input.is_action_just_pressed("ui_move") and not personal_player.is_moving:
		mouse_pos = obj_main_camera.get_global_mouse_position()
		_unused = obj_map.compute_path(personal_player.position, mouse_pos, true, personal_player.movement_dist)
	
	if Input.is_action_pressed("ui_move") and not personal_player.is_moving:
		mouse_pos = obj_main_camera.get_global_mouse_position()
		if is_hex_mouse_different():
			_unused = obj_map.compute_path(personal_player.position, mouse_pos, true, personal_player.movement_dist)

	if Input.is_action_just_released("ui_move"):
		move_player(Global.personal_id, mouse_pos)

	return


func is_hex_mouse_different() -> bool:
	if mouse_pos != last_mouse_pos:
		last_mouse_pos = mouse_pos
		hex_mouse_pos = obj_map.grid_to_hex(mouse_pos, false)
		if hex_mouse_pos != last_hex_mouse_pos:
			last_hex_mouse_pos = hex_mouse_pos
			return true
	return false



func prepare_game() -> void:

	#region loading the players on the map

	var n_character: Node2D
	var player_info: Dictionary

	var default_player: Dictionary = {1: {"username": Global.username, "character": "Default", "team":"red"}}
	var p_spawn_points: Dictionary = {"red": [Vector3(0, 0, 0)], "blue": [], "green": [], "yellow": []}
	var _s_spawn_points: Dictionary = {"red": [Vector3(0, 0, 0)], "blue": [], "green": [], "yellow": []}
	var p_spawn_points_counter: Dictionary = {"red": 0, "blue": 0, "green": 0, "yellow": 0}
	var _s_spawn_points_counter: Dictionary = {"red": 0, "blue": 0, "green": 0, "yellow": 0}

	var hex_position: Vector3

	if Global.offline_mode:
		player_info = default_player

	for i in player_info:
		teams[player_info[i]["team"]].append(i)
		n_character = load("res://Objects/Characters/" + player_info[i]["character"] + ".tscn").instance()
		obj_player_buffer.add_child(n_character)
		n_character.set_info(player_info[i])
		n_character.name = str(i)

		hex_position = p_spawn_points[n_character.team][p_spawn_points_counter[n_character.team]]
		obj_map.occupy_position(hex_position, true)
		n_character.position = obj_map.hex_to_grid(hex_position, false)
		p_spawn_points_counter[n_character.team] += 1

	#endregion

	#region setting up the game bar

	personal_player = get_player_by_id(Global.personal_id)
	selection = personal_player

	#endregion

	return



func get_player_by_id(id: int) -> Node:
	return get_node("Players/" + str(id))


func move_player(player_id: int, to_pos: Vector2) -> void:
	var moving_player: Node = get_player_by_id(player_id)
	if moving_player.is_moving:
		return

	var path = obj_map.compute_path(moving_player.position, to_pos, false, moving_player.movement_dist)
	obj_map.occupy_position(obj_map.grid_to_hex(moving_player.position, false), false)
	obj_map.occupy_position(obj_map.grid_to_hex(path[-1], false), true)
	moving_player.travel(path)

	return


func game_finished()-> void:
	# Do stuff here

	emit_signal("change_scene", "Main_Menu")

	return
