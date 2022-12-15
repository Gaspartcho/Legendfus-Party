extends Node


#region Variables

var players: Dictionary = {}
var room_master: int


#States: 0: Inactive; 1: Lobby (can join); 2: Game creation; 3: In game; 4: End results; 5: Closing
var state: int = 0


var game_rules:Dictionary = {}

#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
