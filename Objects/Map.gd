extends Node2D


func generate_empty_array (x, y):
	# Génère un tableau à 2 dimetions vide (avec que des 0 dedans) de la taille x, y

	var main_array = Array()
	for _i in range(y):
		var row = PoolIntArray()
		for _j in range(x):
			row.append(0)
		main_array.append(row)
	main_array[2][4] = -1
	return main_array


func show_map(main_array):
	# Affiche la titleset en fonction du tableau mis en argument (le fait au centre de l'image)

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


# Liste des indices de la tileSet qui sont valides (on peut marcher ou attaquer dessus)
var valid_cells = [0]

func is_cell_valid(pos):
	# Vérifie si la cellule de la tilemap est bien valide (le perso peut potentiellement bouger ou attaquer dessus) (en gros, la cellule n'est pas vide ou ce n'est pas un obstacle)
	# L'argument "pos" est ici des coordonnées de la titlemap; forme de variable Vector2

	return $Cells.get_cell(pos.x, pos.y) in valid_cells


func select_cell(pos):
	# Indique si la cellule est séléctinnée en lui ajoutant un effet "bleu" ou "rouge" en fonction de si elle est valide ou non
	# L'argument "pos" est ici des coordonnées de la titlemap; forme de variable Vector2

	if is_cell_valid(pos):
		$Selection.set_cell(pos.x, pos.y, 0)
	
	else:
		$Selection.set_cell(pos.x, pos.y, 0)

	return


# Called when the node enters the scene tree for the first time.
func _ready():
	var map_array = generate_empty_array(10, 10)
	show_map(map_array)

	return
