extends Control


#region Variables

#exports variables



#scene objects



#others



#unused variable
var _unused

#endregion



func _ready() -> void:
	hide()


	return



# Exits the setting screen
func _on_Return_button_pressed() -> void:
	hide()
	return 


func _process(_delta) -> void:

	if Input.is_action_just_pressed("settings_toggle"):
		visible = not visible
	
	return	