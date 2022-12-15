extends Node


#region Variables

export var obj_room: PackedScene

export var port: int = 25566
export var max_players: int = 100
export var max_rooms: int = 20


var local_ip: String
var global_ip: String

var players: Dictionary = {}

var rooms: Dictionary = {}


var peer: NetworkedMultiplayerENet


# Unused variable
var _unused

#endregion


# Called when the node enters the scene tree for the first time.
func _ready():
	print("LegendFus Party: Server Side")
	print("Version: " + Global.version)

	print("\n Initialising:")
	local_ip = IP.get_local_addresses()[11]
	print("Local IP: " + local_ip)

	# set the global_ip variable here (later)
	#global_ip = 
	#print("Global IP: " + global_ip)

	peer = NetworkedMultiplayerENet.new()
	var server_succes = peer.create_server(port, max_players)
	if server_succes:
		print("\nAn error occured while the server was setting up!")
		print("Error Code: " + str(server_succes))
		print("Exiting...")
		get_tree().quit()
	print("Server Created!")
	print("Listening on port: " + str(port))

	print("\nSetting up the remaining little things...")
	_unused = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	print("All Done!")



master func register_player(data: Dictionary):
	# Form of the data: {"name":name}
	var id = get_tree().get_rpc_sender_id()
	players[id] = data
	print("A new player connected! (id: " + str(id) + ", number_of_players: " + str(len(players)) + ")")

func _player_disconnected(id: int):
	_unused = players.erase(id)
	print("A player disconected! (id: " + str(id) + ", number_of_players: " + str(len(players)) + ")")


master func create_room():
	pass