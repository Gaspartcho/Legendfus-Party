extends Control


#region Variables

#exports variables



#scene objects
onready var obj_console_input: LineEdit = $Console_Input
onready var obj_scroll_container: ScrollContainer = $ScrollContainer
onready var obj_vbox_container: VBoxContainer = $ScrollContainer/VBoxContainer


#others


#unused variable
var _unused

#endregion


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("ui_accept"):
		var message: String = obj_console_input.text
		obj_console_input.clear()
		if message == "":
			return
		
		if message[0] == "/":
			return
		
		else:
			message = Global.username + ": " + message
			console_log(message)
	
	return	


func console_log(message: String) -> void:
	var n_label: Label = Label.new()
	n_label.autowrap = true
	n_label.text = message
	n_label.name = str(obj_vbox_container.get_child_count())
	obj_vbox_container.add_child(n_label)
	yield(get_tree(), "idle_frame")
	obj_scroll_container.ensure_control_visible(n_label)
	return
