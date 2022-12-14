extends Node

#all the scenes must have this in order to work
signal change_scene (scene)


var _unused


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# connect all the room's signals
	_unused = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

	$CanvasLayer/Room_ip_text.text = "Room IP (local): " + Global.server_info["ip"]
	$CanvasLayer/Nb_players_text.text = "Number of players: 1"

	if not get_tree().is_network_server():
		_unused = rpc("register_player", Global.my_info)
		_unused = rpc("_player_connected")

		$CanvasLayer/Start_button.free() # ca ou autre chose qui montre que seul le server peut lancer la game

	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


remote func _player_connected() -> void:
	var id = get_tree().get_rpc_sender_id()
	Global.server_info["nb_players"] += 1
	print("Player connected !")
	if get_tree().is_network_server():
		rpc_id(id, "register_self", Global.server_info)
	rpc_id(id, "register_player", Global.my_info)

	$CanvasLayer/Nb_players_text.text = "Number of players: " + str(Global.server_info["nb_players"])
	return


func _player_disconnected(id:int) -> void:
	print("Player disconected !")
	Global.player_info.erase(id) # Erase player from info.
	Global.server_info["nb_players"] -= 1
	$CanvasLayer/Nb_players_text.text = "Number of players: " + str(Global.server_info["nb_players"])
	return


remote func register_player(info:Dictionary) -> void:
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	Global.player_info[id] = info
	return


puppet func register_self(info:Dictionary) -> void:
	Global.server_info = info
	$CanvasLayer/Nb_players_text.text = "Number of players: " + str(Global.server_info["nb_players"])
	return


func _on_Back_button_pressed() -> void:
	emit_signal("change_scene", "Main_menu")
	return


puppetsync func launch_game() -> void:
	emit_signal("change_scene", "Party")
	return


#func _on_Start_button_pressed() -> void:
#	rpc("launch_game")
#	return