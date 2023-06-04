extends Control


#region Variables

#exports variables
export var max_logs: int = 100


#scene objects
onready var obj_console_input: LineEdit = $Console_Input
onready var obj_scroll_container: ScrollContainer = $ScrollContainer
onready var obj_vbox_container: VBoxContainer = $ScrollContainer/VBoxContainer


#others
var log_counter: int = 0


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
	n_label.name = str(log_counter)
	obj_vbox_container.add_child(n_label)
	yield(get_tree(), "idle_frame")
	obj_scroll_container.ensure_control_visible(n_label)
	
	log_counter += 1
	if obj_vbox_container.get_child_count() > max_logs:
		obj_vbox_container.get_node(str(log_counter - max_logs)).free()
	return
