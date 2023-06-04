extends Control


#region Variables

#exports variables



#scene objects
onready var obj_disconnect_button: Button = $Disconnect_button


#others



#unused variable
var _unused

#endregion



func _ready() -> void:
	hide()

	if Global.offline_mode:
		obj_disconnect_button.disabled = true


	return



# Exits the setting screen
func _on_Return_button_pressed() -> void:
	hide()
	return 


func _process(_delta) -> void:

	if Input.is_action_just_pressed("settings_toggle"):
		visible = not visible
	
	return	


func _on_Quit_button_pressed():
	Global.close_game()
