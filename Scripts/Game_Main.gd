extends Node

export var nb_players = 2
export(PackedScene) var player_file


var player_counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():

	if nb_players > 4 or nb_players < 2:
		print("Error: Player number invalid")
		nb_players = clamp(nb_players, 2, 4)
	
	for i in range(nb_players):
		var n_player = player_file.instance()
		n_player.player_ID = i
		n_player.position = $Map/Cells.map_to_world(Vector2(i, 0))
		add_child(n_player)
		Global.players_pos.append($Map/Cells.world_to_map(n_player.position))
		n_player.add_to_group("Players")


func _on_Map_move(pos):
	get_tree().get_nodes_in_group("Players")[player_counter].position = pos
	Global.players_pos[player_counter] = $Map/Cells.world_to_map(pos)
	player_counter = (player_counter + 1) % nb_players
