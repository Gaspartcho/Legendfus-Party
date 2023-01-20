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

onready var obj_map: Node2D = $Map
onready var obj_player_buffer: Node = $Players

onready var obj_setting_menu: Control = $Canvas_layer_100/Setting_menu


#others
var teams: Dictionary = {"red": [], "blue": [], "green": [], "yellow": []}

var personal_player: Node
var selection: Node

var pathfinder: AStar

#unused variable
var _unused


#endregion


func _ready() -> void:

	prepare_game()

	pathfinder = obj_map.create_astar_from_tilemap()

	return


func _process(_delta) -> void:
	if Input.is_action_just_pressed("camera_reset"):
		selection = personal_player
	
	if Input.is_action_just_released("character_move"):
		move_player(int(selection.name), obj_main_camera.get_global_mouse_position())

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

	personal_player = get_player_by_id(Global.personal_id)
	selection = personal_player

	#endregion

	return


func move_player(id: int, target_pos: Vector2, scale_to_map: bool = false) -> void:
	# we assume the path is valid and possible and in range
	if not scale_to_map:
		target_pos = obj_map.obj_map_tilemap.world_to_map(target_pos)

	var target_player = get_player_by_id(id)
	if target_player.is_moving:
		return

	var target_player_pos = obj_map.obj_map_tilemap.world_to_map(target_player.position)
	var point_start = pathfinder.get_closest_point(Vector3(target_player_pos.x, target_player_pos.y, 0))
	var point_end = pathfinder.get_closest_point(Vector3(target_pos.x, target_pos.y, 0))

	var path = transpose_vector3_vector2_array(pathfinder.get_point_path(point_start, point_end))
	target_player.move(obj_map.transpose_map_to_world_array(path))

	return


func transpose_vector3_vector2_array(list_init: PoolVector3Array) -> PoolVector2Array:
	var list_final = PoolVector2Array()
	for i in list_init:
		list_final.push_back(Vector2(i.x, i.y))
	return list_final

func get_player_by_id(id: int) -> Node:
	return get_node("Players/" + str(id))


func game_finished()-> void:
	# Do stuff here

	emit_signal("change_scene", "Main_Menu")

	return
