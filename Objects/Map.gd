extends Node2D

export var array_size = Vector2(10, 10)


func generate_empty_array (size):
	# Génère un tableau à 2 dimentions vide (avec que des 0 dedans) de la taille size (vector2)

	var main_array = Array()
	for _i in range(size.y):
		var row = PoolIntArray()
		for _j in range(size.x):
			row.append(0)
		main_array.append(row)
	main_array[2][4] = -1
	return main_array


func show_map(main_array):
	# Affiche la titleset en fonction du tableau mis en argument (le fait au centre de l'image)

	for i in range(array_size.x):
		for j in range(array_size.y):
			var pos = Vector2(i, j) - array_size / 2
			$Cells.set_cell(pos.x, pos.y, main_array[j][i])
	return


# Liste des indices de la tileSet qui sont valides (on peut marcher ou attaquer dessus)
var valid_cells = [0]

func is_cell_valid(pos):
	# Vérifie si la cellule de la tilemap est bien valide (le perso peut potentiellement bouger ou attaquer dessus) (en gros, la cellule n'est pas vide ou ce n'est pas un obstacle)
	# L'argument "pos" est ici des coordonnées de la titlemap; forme de variable Vector2

	return $Cells.get_cell(pos.x, pos.y) in valid_cells


func select_cell(pos):
	if pos != old_pos:
		$Selection.set_cell(pos.x, pos.y, is_cell_valid(pos))

		$Selection.set_cell(old_pos.x, old_pos.y, -1)
		old_pos = pos


# Called when the node enters the scene tree for the first time.
func _ready():
	var map_array = generate_empty_array(array_size)
	show_map(map_array)


func get_sign_vector(vec):
	vec.x = sign(vec.x)
	vec.y = sign(vec.y)
	return vec


# Créée une variable old_pos en dehors de la fonction pour la garder sur plusieurs frames (toute variable définie dans une fonction seras suprimé à la fin de la fonction)
var old_pos = Vector2()
var old_mouse_pos = Vector2()

var input_before = false
var altern = true

func _process(_delta): # Fonction qui arive à chaques frames du jeu
	# Ici, on prend l'input au niveau du clavier ou de la manette (j'y ai passé la journée donc sois impressionné stp...)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2():
		if not input_before:
			direction = get_sign_vector(direction)

			altern = not altern
			var pos

			if direction == Vector2(-1, -1):
				pos = Vector2(-1, 0)
			elif direction == Vector2(-1, 1):
				pos = Vector2(0, 1)
			elif direction == Vector2(1, -1):
				pos = Vector2(0, -1)
			elif direction == Vector2(1, 1):
				pos = Vector2(1, 0)
			
			elif altern:
				if direction == Vector2(-1, 0) or direction == Vector2(0, -1):
					pos = Vector2(-1, 0)
				else:
					pos = Vector2(1, 0)
			else:
				if direction == Vector2(-1, 0) or direction == Vector2(0, 1):
					pos = Vector2(0, 1)
				else:
					pos = Vector2(0, -1)

			print(pos)
			pos += old_pos
			select_cell(pos)
			input_before = true

	else:
		input_before = false


func _input(event): 
	# Détecte si la souris à changée de position
	if event is InputEventMouseMotion:
		# Sélectionne la case sur laquelle la souris est 
		var pos = event.position - OS.window_size / 2
		if old_mouse_pos.distance_squared_to(pos) > 10:
			var pos_m = $Selection.world_to_map(pos)
			select_cell(pos_m)
			old_mouse_pos = pos
