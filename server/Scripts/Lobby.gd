extends Node


#region Variables

#exports variables



#scene objects


#others
var players_in_lobby := PoolIntArray()


#unused variable
var _unused

#endregion


master func player_joined_lobby():
    print("test")
    var id: int = get_tree().get_rpc_sender_id()
    players_in_lobby.append(id)
    rpc_id(id, "get_lobby_info", players_in_lobby)

    return

master func player_left_lobby():
    var id: int = get_tree().get_rpc_sender_id()
    players_in_lobby.remove(players_in_lobby.find(id))