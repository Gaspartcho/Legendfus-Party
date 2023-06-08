extends Node


func _ready():
	pass # Replace with function body.


master func register_player(data: Dictionary):
	# Form of the data: {"name":name}
	var id = get_tree().get_rpc_sender_id()
	Global.players[id] = data
	print("A new player connected! (id: " + str(id) + ", number_of_players: " + str(len(Global.players)) + ")")
	print(data["name"])