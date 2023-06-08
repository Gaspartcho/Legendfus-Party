extends Node


signal change_scene (scene)


#region Variables

#exports variables
export var default_server_adress: String = ""
export var server_port: int = 25566


#scene objects
onready var obj_server_adress_input: LineEdit = $CanvasLayer/server_adress_input
onready var obj_server_port_input: SpinBox = $CanvasLayer/server_port_input


#others



#unused variable
var _unused

#endregion



func _ready() -> void:
	get_tree().network_peer = null

	_unused = get_tree().connect("connection_failed", self, "_on_connection_failed")
	_unused = get_tree().connect("connected_to_server", self, "_on_connected_to_server")

	return

func _on_connect_server_button_pressed() -> void:
	var adress = obj_server_adress_input.text
	var port = int(obj_server_port_input.value)
	connect_server(adress, port)

	return


func _on_Offline_button_pressed() -> void:
	Global.offline_mode = true
	Global.personal_id = 1
	get_tree().network_peer = null
	emit_signal("change_scene", "Main_Menu")

	return


# connections issues when working on the same computer
func connect_server(adress: String = default_server_adress, port: int = server_port) -> void:
	var peer = NetworkedMultiplayerENet.new()
	# Add handling of errors (later)
	peer.create_client(adress, port)
	get_tree().network_peer = peer

	# add animation to show it's trying to connect to the server

	return


func _on_connected_to_server() -> void:
	print("Connected Success!")
	Global.personal_id = get_tree().get_network_unique_id()
	Global.offline_mode = false
	rpc_id(0, "register_player", {"name": Global.username})
	emit_signal("change_scene", "Main_Menu")

	return
	

func _on_connection_failed() -> void:
	print("Can\'t connect to server")
	obj_server_adress_input.clear()
	get_tree().network_peer = null

	# shows an error message, end all connecting animations

	return