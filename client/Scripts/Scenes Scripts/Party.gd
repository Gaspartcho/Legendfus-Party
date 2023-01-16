extends Node


signal change_scene (scene)


#region Variables

#exports variables
export var camera_speed: float = 1
export var camera_friction: float = 1.3
export var camera_zoom_speed: float = 1.07
export var zoom_limits: Dictionary = {"min": 0.25, "max": 4.0}


#scene objects
onready var obj_Setting_menu: Control = $Canvas_layer_100/Setting_menu
onready var obj_main_camera: Camera2D = $Main_camera

onready var obj_map: Node2D = $Map
onready var obj_player_buffer: Node = $Players


#others
var camera_momentum: Vector2 = Vector2(0, 0)

var teams: Dictionary = {"red": [], "blue": [], "green": [], "yellow": []}

#vars for the _process function
onready var vp_size: Vector2 = get_viewport().size
var cam_zoom_offset: float = 1 - 1 / camera_zoom_speed
var cam_unzoom_offset: float = camera_zoom_speed - 1

#unused variable
var _unused

#endregion


func _ready() -> void:

	prepare_game()

	return


func _process(delta) -> void:
	var m_pos = get_viewport().get_mouse_position()
	var has_moved = false

	if m_pos.x <= 0:
		camera_momentum.x = -camera_speed
		has_moved = true
	if m_pos.y <= 0:
		camera_momentum.y = -camera_speed
		has_moved = true
	if m_pos.x >= vp_size.x - 1:
		camera_momentum.x = camera_speed
		has_moved = true
	if m_pos.y >= vp_size.y - 1:
		camera_momentum.y = camera_speed
		has_moved = true
	
	if not has_moved:
		if camera_momentum.x < 1 and camera_momentum.x > -1 and camera_momentum.x != 0:
			camera_momentum.x = 0
		elif camera_momentum.y < 1 and camera_momentum.y > -1 and camera_momentum.y != 0:
			camera_momentum.y = 0
		else:
			camera_momentum /= camera_friction

	obj_main_camera.position += camera_momentum * obj_main_camera.zoom * delta
	
	if Input.is_action_just_released("map_zoom") and obj_main_camera.zoom.x > zoom_limits["min"]:
		obj_main_camera.position += (m_pos - vp_size / 2) * cam_zoom_offset * obj_main_camera.zoom
		obj_main_camera.zoom /= camera_zoom_speed

	if Input.is_action_just_released("map_unzoom") and obj_main_camera.zoom.x < zoom_limits["max"]:
		obj_main_camera.position -= (m_pos - vp_size / 2) * cam_unzoom_offset * obj_main_camera.zoom
		obj_main_camera.zoom *= camera_zoom_speed

	if Input.is_action_just_pressed("camera_reset"):
		obj_main_camera.position = get_node("Players/" + str(Global.personal_id)).position
		obj_main_camera.zoom = Vector2(1, 1)

	
	return


func prepare_game() -> void:
	var n_character: Node2D
	var player_info = Global.players

	var p_spawn_points: Dictionary = {"red": [Vector2(0, 0)], "blue": [], "green": [], "yellow": []}
	var _s_spawn_points: Dictionary = {"red": [Vector2(0, 0)], "blue": [], "green": [], "yellow": []}
	var p_spawn_points_counter: Dictionary = {"red": 0, "blue": 0, "green": 0, "yellow": 0}
	var _s_spawn_points_counter: Dictionary = {"red": 0, "blue": 0, "green": 0, "yellow": 0}

	if not player_info:
		player_info = {1: {"username": Global.username, "character": "Default", "team":"red"}}

	for i in player_info:
		teams[player_info[i]["team"]].append(i)
		n_character = load("res://Objects/Characters/" + player_info[i]["character"] + ".tscn").instance()
		obj_player_buffer.add_child(n_character)
		n_character.set_info(player_info[i])
		n_character.name = str(i)
		n_character.position = p_spawn_points[n_character.team][p_spawn_points_counter[n_character.team]]
		p_spawn_points_counter[n_character.team] += 1

	return
