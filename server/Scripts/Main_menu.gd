extends Node


#region variables


#endregion


master func player_data_change(property: String, new_value):
	var player_id: int = get_tree().get_rpc_sender_id()
	Global.players[player_id][property] = new_value
	print("Player {id} has changed {property} to {value}".format({"id": player_id, "property": property, "value": new_value}))

	return