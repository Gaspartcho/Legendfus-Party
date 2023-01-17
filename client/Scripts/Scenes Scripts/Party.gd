extends Node


signal change_scene (scene)


#region Variables

#exports variables
export var turn: String = "red"


#scene objects
onready var obj_Setting_menu: Control = $Canvas_layer_100/Setting_menu
onready var obj_main_camera: Camera2D = $Main_camera

onready var obj_map: Node2D = $Map
onready var obj_player_buffer: Node = $Players


#others
var teams: Dictionary = {"red": [], "blue": [], "green": [], "yellow": []}

var personal_player: Node


#unused variable
var _unused


#endregion


func _ready() -> void:

	prepare_game()

	return

func prepare_game() -> void:

	#region loading the players on the map

	var n_character: Node2D
	var player_info = Global.players

	var default_player: Dictionary = {1: {"username": Global.username, "character": "Default", "team":"red"}}
	var p_spawn_points: Dictionary = {"red": [Vector2(0, 0)], "blue": [], "green": [], "yellow": []}
	var _s_spawn_points: Dictionary = {"red": [Vector2(0, 0)], "blue": [], "green": [], "yellow": []}
	var p_spawn_points_counter: Dictionary = {"red": 0, "blue": 0, "green": 0, "yellow": 0}
	var _s_spawn_points_counter: Dictionary = {"red": 0, "blue": 0, "green": 0, "yellow": 0}

	if not player_info:
		player_info = default_player

	for i in player_info:
		teams[player_info[i]["team"]].append(i)
		n_character = load("res://Objects/Characters/" + player_info[i]["character"] + ".tscn").instance()
		obj_player_buffer.add_child(n_character)
		n_character.set_info(player_info[i])
		n_character.name = str(i)
		n_character.position = p_spawn_points[n_character.team][p_spawn_points_counter[n_character.team]]
		p_spawn_points_counter[n_character.team] += 1

	#endregion

	#region setting up the game bar

	personal_player = get_node("Players/" + str(Global.personal_id))

	#endregion

	return

func game_finished()-> void:
	# Do stuff here

	emit_signal("change_scene", "Main_Menu")

	return