extends Node


signal change_scene (scene)


#region Variables

#exports variables



#scene objects
onready var obj_nb_players_text: Label = $CanvasLayer/Nb_players_text


#others
var players_in_lobby := PoolIntArray()


#unused variable
var _unused

#endregion

func ready():
	players_in_lobby.append(get_tree().get_network_unique_id())
	rpc("player_joined_lobby")


	return

func _on_Back_button_pressed():
	rpc("player_left_lobby")
	emit_signal("change_scene", "Main_menu")

	return


puppet func get_lobby_info(players: PoolIntArray):
	players_in_lobby.append_array(players)
	obj_nb_players_text.text = "Number of players: " + str(players_in_lobby.size())

	return

remote func player_joined_lobby():
	var id: int = get_tree().get_rpc_sender_id()
	players_in_lobby.append(id)

	return

remote func player_left_lobby():
	var id: int = get_tree().get_rpc_sender_id()
	players_in_lobby.remove(players_in_lobby.find(id))
	obj_nb_players_text.text = "Number of players: " + str(players_in_lobby.size())

	return