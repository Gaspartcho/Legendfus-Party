extends Node


#region Variables

export var obj_room: PackedScene

export var port: int = 25566
export var max_players: int = 100
export var max_rooms: int = 20


var local_ip: String
var global_ip: String

var rooms: Dictionary = {}


# Unused variable
var _unused

#endregion


# Called when the node enters the scene tree for the first time.
func _ready():
	print("LegendFus Party: Server Side")
	print("Version: " + str(Global.game_version))

	print("\nInitialising:")

	var peer = NetworkedMultiplayerENet.new()
	var server_succes = peer.create_server(port, max_players)
	if server_succes:
		print("\nAn error occured while the server was setting up!")
		print("Error Code: " + str(server_succes))
		print("Exiting...")
		get_tree().quit()

	print("Server Created!")
	print("Listening on port: " + str(port))

	print("\nSetting up the remaining little things...")
	get_tree().network_peer = peer
	_unused = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	print("All Done!")


func exit_program() -> void:
	print("Shutting down the program")
	get_tree().network_peer.close_connection()
	get_tree().quit()

func _player_disconnected(id: int):
	_unused = Global.players.erase(id)
	print("A player disconected! (id: " + str(id) + ", number_of_players: " + str(len(Global.players)) + ")")


master func create_room(title: String, nb_players: int, teams: PoolIntArray) -> void:
	var id = get_tree().get_rpc_sender_id()
	if id in rooms:
		rpc_id(id, "server_error", "You only can create one room at a time")
		print("User " + str(id) + "Tried to create more than a room at a time")
		return
	
	if len(rooms) >= 20:
		rpc_id(id, "server_error", "Maximum number of rooms reached!")
		print("User " + str(id) + "Tried to create a room but there was already too much of them...")
		return
	
	var n_room: Node = obj_room.instance()
	var room_name = "Room " + str(id)
	n_room.set_name(room_name)
	rooms[id] = room_name
	n_room.initialise(id, title, nb_players, teams)
	add_child(n_room)
	rpc_id(id, "room_created")

	return
	

master func request_refresh():
	var id = get_tree().get_rpc_sender_id()
	var data = {}
	for i in rooms:
		var temp = get_node(rooms[i]).get_info()
		if rooms[i].get_info() != null:
			data[i] = temp

	rpc_id(id, "answer_request", data)

master func join_room():
	pass