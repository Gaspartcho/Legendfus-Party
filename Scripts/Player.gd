extends Node2D

export var player_ID = 0
export var active = true
export var move_points = 2
export var move_speed = 400
export var move_posibilities : PoolVector2Array


var destination : Vector2
var velocity : Vector2


func get_normal_pos (length : int = 1) -> PoolVector2Array:
	# determines a range of positions the player can move to in "lenght" jumps
	var all_pos = PoolVector2Array()
	for i in range (2 * length + 1):
		var x_pos = i - length
		var y_num = length - abs(x_pos)
		for j in range(2 * y_num + 1):
			var y_pos = j - y_num
			all_pos.append(Vector2(x_pos, y_pos))
	return all_pos


func move (pos:Vector2, spd: int = move_speed) -> void:
	destination = pos
	velocity = position.direction_to(destination) * spd
	$Moving_Timer.start(position.distance_to(pos) / spd)
	return


func _on_Moving_Timer_timeout () -> void:
	position = destination
	return


# Called when the node enters the scene tree for the first time.
func _ready () -> void:
	move_posibilities = get_normal_pos(move_points)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	if not $Moving_Timer.is_stopped():
		position += velocity * delta
	return

