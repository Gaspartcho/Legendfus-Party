extends Node


#region Variables

#exports variables
export var start_scene: PackedScene
export var offline_mode: bool = false
export var debug_mode: bool = false


#scene objects
onready var obj_game_version_label: Label = $Canvas_layer_10/Game_version_label
onready var obj_offline_mode_label: Label = $Canvas_layer_10/Debug_menu/Offline_mode_label
onready var obj_connected_label: Label = $Canvas_layer_10/Debug_menu/Connected_label
onready var obj_sever_adress_label: Label = $Canvas_layer_10/Debug_menu/Sever_adress_label
onready var obj_server_port_label: Label = $Canvas_layer_10/Debug_menu/Server_port_label
onready var obj_mouse_pos_label: Label = $Canvas_layer_10/Debug_menu/Mouse_pos_label
onready var obj_fps_label: Label = $Canvas_layer_10/Debug_menu/FPS_label

onready var obj_debug_menu: Control = $Canvas_layer_10/Debug_menu


#others
var current_scene: String



#unused variable
var _unused

#endregion


func _ready() -> void:
	#Step 1: loading the first scene

	obj_game_version_label.text = Global.game_version
	obj_offline_mode_label.text = "Offline Mode: True"

	var begin_scene = start_scene.instance()
	current_scene = begin_scene.name
	add_child(begin_scene)

	_unused = begin_scene.connect("change_scene", self, "change_scene")
	_unused = get_tree().connect("server_disconnected", self, "_on_server_disconnected")

	if offline_mode:
		change_scene("Main_Menu")
	

	#Step 2: doing others things
	Global.offline_mode = offline_mode

	if debug_mode:
		obj_debug_menu.show()
	else:
		obj_debug_menu.hide()

	
	return


func _process(_delta) -> void:
	obj_fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

	if Input.is_action_just_pressed("debug_toggle"):
		debug_mode = not debug_mode
		if debug_mode:
			obj_debug_menu.show()
		else:
			obj_debug_menu.hide()
	
	return


func _input(event) -> void:
	if event is InputEventMouseMotion:
		obj_mouse_pos_label.text = "Mouse pos: " + str(event.position)

	return


func change_scene(scene:String) -> void:
	print("changing scene!")
	var removed_scene = get_node(current_scene)
	removed_scene.call_deferred("queue_free")
	remove_child(removed_scene)
	removed_scene.call_deferred("free")

	# Note pour plus tard: ajouter un écran de chargement ici

	var next_level = load("res://Scenes/" + scene + ".tscn").instance()
	add_child(next_level)
	next_level.connect("change_scene", self, "change_scene")
	current_scene = scene

	return


func _on_server_disconnected() -> void:
	Global.personal_id = 1
	change_scene("Connecter")
	print("Server Disconected!")

	return
