extends Node


#region Variables

#exports variables
export var start_scene: PackedScene
export var offline_mode: bool = false


#scene objects
onready var obj_game_version_label: Label = $Canvas_layer_10/Game_version_label
onready var obj_debug_menu: Control = $Canvas_layer_10/Debug_menu

onready var obj_mouse_helper: Node2D = $Mouse_helper


#others
var current_scene: String



#unused variable
var _unused

#endregion


func _ready() -> void:
	#Step 1: loading the first scene
	obj_game_version_label.text = Global.game_version
	obj_debug_menu.obj_mouse_helper = obj_mouse_helper

	var begin_scene = start_scene.instance()
	current_scene = begin_scene.name
	add_child(begin_scene)

	_unused = begin_scene.connect("change_scene", self, "change_scene")
	_unused = get_tree().connect("server_disconnected", self, "_on_server_disconnected")

	if offline_mode:
		change_scene("Main_Menu")
	

	#Step 2: doing others things
	Global.offline_mode = offline_mode
	
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

	obj_debug_menu.reload()

	return


func _on_server_disconnected() -> void:
	Global.personal_id = 1
	change_scene("Connecter")
	print("Server Disconected!")

	return
