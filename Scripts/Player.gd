extends Node2D

export var player_ID = 0
export var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_move(pos):
	self.position = pos
	self.visible = true
