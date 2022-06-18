extends Node2D


func generate_empty_array (x, y):
	var main_array = Array()
	for _i in range(y):
		var row = PoolIntArray()
		for _j in range(x):
			row.append(0)
		main_array.append(row)
	main_array[2][4] = -1
	return main_array


func show_map(main_array):
	var a_length = len(main_array[0])
	var a_height = len(main_array)
	var xpos
	var ypos
	for i in range(a_height):
		for j in range(a_length):
			xpos = j - a_length / 2
			ypos = i - a_height / 2
			$Cells.set_cell(xpos, ypos, main_array[i][j])
	return


# Called when the node enters the scene tree for the first time.
func _ready():
	var map_array = generate_empty_array(10, 10)
	show_map(map_array)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
