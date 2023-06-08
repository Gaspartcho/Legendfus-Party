extends Node


#region variables

const game_version: String = "LegendFus Party: Prototype 0.1 - Server"


var players: Dictionary = {}


enum {IDLE, IN_LOBBY, IN_GAME}
var game_state: int = IDLE


#endregion
