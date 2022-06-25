extends Node2D

export var player_ID = 0
export var active = true
export var move_points = 1


var move_posibilities


func get_normal_pos (length = 1):
	var all_pos = PoolVector2Array()
	for i in range (2 * length + 1):
		var x_pos = i - length
		var y_num = length - abs(x_pos)
		for j in range(2 * y_num + 1):
			var y_pos = j - y_num
			all_pos.append(Vector2(x_pos, y_pos))
	return all_pos


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true
	move_posibilities = get_normal_pos(move_points)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass