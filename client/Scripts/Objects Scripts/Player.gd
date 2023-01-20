extends Node2D


#region Variables

#exports variables
#Using dictionaries for attacks, waiting to be able to export the custom classes
export var character_name: String = "Default"
export var life: int = 10
export var shield: int = 5

export var movement_dist: int = 5
export var vision_dist: int = 10
export var radio_dist: int = 10

export var attack_1: Resource = load("res://Resources/Attack.tres")
export var attack_2: Resource = load("res://Resources/Attack.tres")
export var attack_3: Resource = load("res://Resources/Attack.tres")
export var attact_4: Resource = load("res://Resources/Attack.tres")
export var attack_u: Resource = load("res://Resources/Attack.tres")

export var movement_speed: float = 3


#scene objects
onready var obj_username_label: Label = $Username_label
onready var obj_movement_tween: Tween = $Movement_tween


#others
onready var attacks: Array = [attack_1, attack_2, attack_3, attact_4, attack_u]
var team: String = "red"
var is_alive: bool = true
var is_moving: bool = false

#unused variable
var _unused

#endregion



func set_info(data: Dictionary) -> void:
	obj_username_label.text = data["username"]
	team = data["team"]
	

	return


func move(targets: PoolVector2Array) -> void:
	# Vector2 s on world scale
	_unused = obj_movement_tween.start()
	is_moving = true
	for i in targets:
		_unused = obj_movement_tween.interpolate_property(self, "position", position, i, position.distance_to(i) / movement_speed)
		yield(obj_movement_tween, "tween_completed")
	
	is_moving = false
	return