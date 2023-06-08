extends Node


signal change_scene (scene)


#region Variables

#exports variables



#scene objects
onready var obj_Setting_menu: Control = $Canvas_layer_100/Setting_menu

onready var obj_username_label: Label = $Main_canvas/Username_label
onready var obj_username_input: LineEdit = $Main_canvas/Player_name_input


#others



#unused variable
var _unused

#endregion


func _ready() -> void:
	obj_username_label.text = Global.username

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


func _on_Set_username_button_pressed():
	var new_username: String = obj_username_input.text
	if new_username != "":
		Global.username = new_username
		obj_username_label.text = new_username
	
	return
	
