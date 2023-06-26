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
	if not Global.offline_mode:
		rpc_id(1, "can_player_join_game")
	return

puppet func answer_can_join_game(answer: bool, message: String):
	if answer:
		emit_signal("change_scene", "Lobby")
	print(message)
	return

func _on_Setting_button_pressed() -> void:
	obj_Setting_menu.show()

	return


func _on_Set_username_button_pressed():
	var new_username: String = obj_username_input.text
	if new_username != "":
		Global.username = new_username
		obj_username_label.text = new_username
		if not Global.offline_mode:
			rpc_id(0, "player_data_change", "name", new_username)
	
	return
	
