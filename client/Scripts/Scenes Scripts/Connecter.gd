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

# connections issues when working on the same computer
func connect_server(adress: String = default_server_adress, port: int = server_port) -> void:
	var peer = NetworkedMultiplayerENet.new()
	# Add handling of errors (later)
	peer.create_client(adress, port)
	get_tree().network_peer = peer

	# add animation to show it's trying to connect to the server

	return


func _on_connection_failed() -> void:
	print("Can\'t connect to server")
	obj_server_adress_input.clear()
	get_tree().network_peer = null

	# shows an error message, end all connecting animations

	return


func _on_connected_to_server() -> void:
	print("Connected Success!")
	emit_signal("change_scene", "Main_Menu")

	return
