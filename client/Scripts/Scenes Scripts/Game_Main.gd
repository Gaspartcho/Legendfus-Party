extends Node


#region Variables

#exports variables
export var current_scene: String = "Connecter"
export var offline_mode: bool = false
export var debug_mode: bool = false


#scene objects
onready var obj_game_version_label: Label = $Canvas_layer_128/Game_version_label
onready var obj_offline_mode_label: Label = $Canvas_layer_128/Debug_menu/Offline_mode_label
onready var obj_connected_label: Label = $Canvas_layer_128/Debug_menu/Connected_label
onready var obj_sever_adress_label: Label = $Canvas_layer_128/Debug_menu/Sever_adress_label
onready var obj_server_port_label: Label = $Canvas_layer_128/Debug_menu/Server_port_label

onready var obj_debug_menu: Control = $Canvas_layer_128/Debug_menu


#others



#unused variable
var _unused

#endregion


func _ready() -> void:

	obj_game_version_label.text = Global.game_version

	if offline_mode:
		obj_offline_mode_label.text = "Offline Mode: True"
		var begin_scene = load("res://Scenes/Main_Menu.tscn").instance()
		add_child(begin_scene)
		begin_scene.connect("change_scene", self, "change_scene")
		return
	
	var begin_scene = load("res://Scenes/" + current_scene + ".tscn").instance()
	add_child(begin_scene)
	begin_scene.connect("change_scene", self, "change_scene")

	_unused = get_tree().connect("server_disconnected", self, "_on_server_disconnected")

	return


func _process(_delta) -> void:


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
	change_scene("Connecter")
	print("Server Disconected!")

	return
