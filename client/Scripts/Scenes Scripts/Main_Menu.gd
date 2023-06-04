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


func _ready() -> void:

	return


func _on_Quit_button_pressed() -> void:
	Global.close_game()

	return

func _on_Create_game_button_pressed() -> void:
	emit_signal("change_scene", "Party")
	return

func _on_Setting_button_pressed() -> void:
	obj_Setting_menu.show()

	return
