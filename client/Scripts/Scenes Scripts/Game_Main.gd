extends Node


#region Variables

#exports variables
export var current_scene: String = "Connecter"


#scene objects
onready var obj_game_version_label: Label = $Main_canvas/Game_version_label


#others



#unused variable
var _unused

#endregion


func _ready() -> void:

	obj_game_version_label.text = Global.game_version
	
	var begin_scene = load("res://Scenes/" + current_scene + ".tscn").instance()
	add_child(begin_scene)
	begin_scene.connect("change_scene", self, "change_scene")

	_unused = get_tree().connect("server_disconnected", self, "_on_server_disconnected")

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
