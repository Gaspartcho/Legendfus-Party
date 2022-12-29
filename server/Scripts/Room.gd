extends Node


#region Variables

var room_master: int


#States: 0: Inactive; 1: Lobby (can join); 2: Game creation; 3: In game; 4: End results; 5: Closing
var state: int = 0
var max_players: int = 16
#Room's User Given Name
var title: String = "Default"
var teams: Array = [1, 2, 3, 4]
var id: int
var players: Array = []

#unused variable
var _unused

#endregion


func initialise(r_master, r_name, r_max_players, r_teams):
	room_master = r_master
	title = r_name
	max_players = r_max_players
	teams = r_teams

	pass # Replace with function body.


func get_info() -> Dictionary:
	if state != 1:
		return {}
	return {"name": title, "max_players": max_players, "nb_players": len(players)}
	
