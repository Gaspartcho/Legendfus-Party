extends Node

signal change_scene (scene)


var _unused

# Called when the node enters the scene tree for the first time.
func _ready():
	_unused = get_tree().connect("connected_to_server", self, "_connected_ok")


	get_tree().network_peer = null
	$CanvasLayer/Player_name_input.text = Global.my_info["name"]

	print(IP.get_local_addresses())

	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_Quit_button_pressed() -> void:
	# Shuts down the game

	get_tree().quit()

	return


func get_local_ip():
	return IP.get_local_addresses()[11]


func _on_Host_button_pressed() -> void:
	var player_name = $CanvasLayer/Player_name_input.text
	if player_name == "":
		print("Invalid name!")
		return
	Global.my_info["name"] = player_name
	var p_ip = get_local_ip()
	print(p_ip)
	Global.my_info["ip"] = p_ip

	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(Global.server_port, Global.server_info["max_players"])
	get_tree().network_peer = peer
	Global.server_info["ip"] = p_ip
	Global.server_info["port"] = Global.server_port
	Global.server_info["nb_players"] = 1

	print("server created")
	emit_signal("change_scene", "Lobby")

	return


func _on_Connect_button_pressed() -> void:
	var player_name = $CanvasLayer/Player_name_input.text
	if player_name == "":
		print("Invalid name!")
		return
	Global.my_info["name"] = player_name
	var p_ip = get_local_ip()
	Global.my_info["ip"] = p_ip
	
	var server_ip = $CanvasLayer/Server_ip_input.text
	if server_ip == "":
		print("Invalid adress!")
		return
	Global.server_info["ip"] = server_ip

	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(server_ip, Global.server_port)
	get_tree().network_peer = peer

	return


func _connected_ok() -> void:
	print("All went acordingly!")
	emit_signal("change_scene", "Lobby")

	return

func _on_Button_pressed() -> void:
	pass