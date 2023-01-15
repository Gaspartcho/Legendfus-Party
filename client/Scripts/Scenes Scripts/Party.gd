extends Node


signal change_scene (scene)


#region Variables

#exports variables
export var camera_speed: float = 1


#scene objects
onready var obj_Setting_menu: Control = $Canvas_layer_100/Setting_menu

onready var obj_map: Node2D = $Main_canvas/Map
onready var obj_player_buffer: Node = $Main_canvas/Players


onready var obj_game_main = get_node("/root/Game_Main")


#others
const p_spawn_points: Dictionary = {"red": [Vector2(0, 0)], "blue": [], "green": [], "yellow": []}
const s_spawn_points: Dictionary = {"red": [Vector2(0, 0)], "blue": [], "green": [], "yellow": []}
var p_spawn_points_counter: Dictionary = {"red": 0, "blue": 0, "green": 0, "yellow": 0}
var s_spawn_points_counter: Dictionary = {"red": 0, "blue": 0, "green": 0, "yellow": 0}

var teams: Dictionary = {"red": [], "blue": [], "green": [], "yellow": []}


#unused variable
var _unused

#endregion


func _ready() -> void:
	return


func prepare_game() -> void:
	var n_character: Node2D
	var player_info = Global.players

	if not player_info:
		player_info = {1: {"username": Global.username, "character": "Default", "team":"Red"}}

	for i in player_info:
		teams[player_info[i]["team"]].append(i)
		n_character = load("res://Objects/Characters/" + player_info[i]["character"] + ".tscn").instance()
		n_character.set_info(player_info[i])
		n_character.name = str(i)
		n_character.position = p_spawn_points[n_character.team][p_spawn_points_counter[n_character.team]]
		s_spawn_points_counter[n_character.team] += 1

		obj_player_buffer.add_child(n_character)

	return
