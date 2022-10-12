extends Node

signal change_scene (scene)


export var default_game: bool = true


var players_pos


var players_done = []


func pre_configure_game():
	get_tree().paused = true
	var selfPeerID = get_tree().get_network_unique_id()

	# Load my player
	var my_player = Global.get_character("default")
	my_player.set_name(str(selfPeerID))
	$Players.add_child(my_player)

	# Load other players
	for p in Global.player_info:
		var player = Global.get_character("default")
		player.set_name(str(p))
		$Players.add_child(player)


	# Tell the server we're done
	rpc_id(1, "done_preconfiguring")


mastersync func done_preconfiguring():
	var who = get_tree().get_rpc_sender_id()

	assert(who in Global.player_info or who == 1) # Exists
	assert(not who in players_done) # Was not added yet

	players_done.append(who)

	if players_done.size() == Global.server_info["nb_players"]:
		rpc("post_configure_game")


puppetsync func post_configure_game():
	get_tree().paused = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pre_configure_game()




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
