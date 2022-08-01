extends Node

export var nb_players = 2
export(PackedScene) var player_file


var curent_player = 0
var player_array : Array
var players_pos = Global.players_pos


func change_player(player, increment=true):
	if increment:
		curent_player = (curent_player + 1) % nb_players

	$Map.display_pos(player_array[player].move_posibilities, players_pos[curent_player])
	
	$Main_Camera.position = $Map/Cells.map_to_world(players_pos[curent_player])
	Global.camera_offset = $Main_Camera.position



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
		players_pos.append($Map/Cells.world_to_map(n_player.position))
		n_player.add_to_group("Players")
	
	player_array = get_tree().get_nodes_in_group("Players")
	change_player(curent_player, false)


func _on_Map_move(pos):
	player_array[curent_player].move(pos)
	players_pos[curent_player] = $Map/Cells.world_to_map(pos)
	change_player(curent_player)
