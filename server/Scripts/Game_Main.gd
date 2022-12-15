extends Node


#region Variables

export var obj_room: PackedScene

export var port: int = 25566


var local_ip: int
var global_ip: int

var players: Dictionary = {}

#endregion


# Called when the node enters the scene tree for the first time.
func _ready():
	print("")
	local_ip = IP.get_local_addresses()[11]
	# set the global_ip variable here (later)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
