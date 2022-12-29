extends Node


signal change_scene (scene)


#region Variables

#exports variables



#scene objects
onready var obj_Setting_menu: Control = $Canvas_layer_100/Setting_menu


#others



#unused variable
var _unused

#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	$Popup.popup()
	return


func _on_Quit_button_pressed() -> void:
	# Shuts down the game
	get_tree().network_peer.close_connection()
	get_tree().network_peer = null
	get_tree().quit()

	return

func _on_Create_game_button_pressed() -> void:
	print("Hello World")

	return

func _on_Setting_button_pressed() -> void:
	obj_Setting_menu.show()

	return