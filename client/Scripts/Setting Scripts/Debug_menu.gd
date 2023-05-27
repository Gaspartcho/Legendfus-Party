extends VBoxContainer


#region Variables

#scene objects
onready var obj_offline_mode_label: Label = $Offline_mode_label
onready var obj_sever_adress_label: Label = $Sever_adress_label
onready var obj_server_port_label: Label = $Server_port_label
onready var obj_mouse_pos_label: Label = $Mouse_pos_label
onready var obj_mouse_real_pos_label: Label = $Mouse_real_pos_label
onready var obj_fps_label: Label = $FPS_label

#others

onready var obj_mouse_helper: Node2D = get_node("/root/Game_Main/Mouse_helper")


#unused variable
var _unused

#endregion


func _ready() -> void:
	
	reload()

	return


func _process(_delta: float) -> void:
	obj_fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

	if Input.is_action_just_pressed("debug_toggle"):
		visible = not visible

	return


func reload() -> void:
	obj_offline_mode_label.text = "Offline Mode: " + str(Global.offline_mode)

	if Global.offline_mode:
		obj_sever_adress_label.text = "Server Adress: None"
		obj_server_port_label.text = "Server Port: None"

	else:
		obj_sever_adress_label.text = "Server Adress: " + str(Global.server_adress)
		obj_server_port_label.text = "Server Port: " + str(Global.server_port)
		
	return


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		obj_mouse_pos_label.text = "Mouse pos: " + str(event.position)
		obj_mouse_real_pos_label.text = "Mouse Real Pos: " + str(obj_mouse_helper.get_local_mouse_position().round())
	return
