extends Node

signal mouseMoved

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var old_mouse_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()