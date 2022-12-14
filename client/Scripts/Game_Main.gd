extends Node


var current_scene:String
var _unused


func _ready() -> void:
	
	current_scene = "Main_menu"
	
	_unused = get_node(current_scene).connect("change_scene", self, "change_scene")

	_unused = get_tree().connect("connection_failed", self, "_connected_fail")
	_unused = get_tree().connect("server_disconnected", self, "_connected_fail")

	return

func _process(_delta) -> void:

	return

func change_scene(scene:String) -> void:
	print("changing scene!")
	var removed_scene = get_node(current_scene)
	removed_scene.call_deferred("queue_free")
	remove_child(removed_scene)
	removed_scene.call_deferred("free")

	var next_level = load("res://Scenes/" + scene + ".tscn").instance()
	add_child(next_level)
	next_level.connect("change_scene", self, "change_scene")
	current_scene = scene

	return

func _connected_fail() -> void:
	change_scene("Main_menu")
	print("Failed to connect / connection lost")

	return