extends Node2D


signal move (pos)


# Variables qu'on veut voir dans l'éditeur
export var array_size = Vector2(10, 10)
export var active = true # si le script est actif


# Créée une variable old_pos en dehors de la fonction pour la garder sur plusieurs frames (toute variable définie dans une fonction seras suprimé à la fin de la fonction)
var old_pos = Vector2()
var old_mouse_pos = Vector2()

var input_before = false
var altern = true

var valid_cells = [0] # Liste des indices de la tileSet qui sont valides (on peut marcher ou attaquer dessus)

var reach_cells = PoolVector2Array() # Liste des positions sur léquelles le perso peut effecturer ses actions (en fonctions de ses capacités à lui)

func generate_empty_array (size:Vector2) -> Array:
	# Génère un tableau à 2 dimentions vide (avec que des 0 dedans) de la taille size (vector2)

	var main_array = Array()
	for _i in range(size.y):
		var row = PoolIntArray()
		for _j in range(size.x):
			row.append(0)
		main_array.append(row)
	main_array[2][4] = -1
	return main_array


func show_map (main_array:Array) -> void:
	# Affiche la titleset en fonction du tableau mis en argument (le fait au centre de l'image)

	for i in range(array_size.x):
		for j in range(array_size.y):
			var pos = Vector2(i, j) - array_size / 2
			$Cells.set_cell(pos.x, pos.y, main_array[j][i])
	return


func display_pos (move_posibilities:PoolVector2Array, ref:Vector2) -> void:
	$Possible.clear()
	reach_cells.resize(0)
	for i in move_posibilities:
		var this_pos = i + ref
		reach_cells.append(this_pos)
		$Possible.set_cell(this_pos.x, this_pos.y, 2)
	return


func is_cell_valid (pos:Vector2) -> bool:
	# Vérifie si la cellule de la tilemap est bien valide (le perso peut potentiellement bouger ou attaquer dessus) (en gros, la cellule n'est pas vide ou ce n'est pas un obstacle)
	# L'argument "pos" est ici des coordonnées de la titlemap; forme de variable Vector2
	var check = ($Cells.get_cell(pos.x, pos.y) in valid_cells) and !(pos in Global.players_pos) and (pos in reach_cells)
	return check


func select_cell (pos:Vector2):
	if pos != old_pos:
		$Selection.set_cell(pos.x, pos.y, is_cell_valid(pos))

		$Selection.set_cell(old_pos.x, old_pos.y, -1)
		old_pos = pos
	return
		

func _ready (): # Called when the node enters the scene tree for the first time.
	var map_array = generate_empty_array(array_size)
	Global.map_array = map_array
	show_map(map_array)



# pas sur de vouloir mettre les inputs dans l'objet "carte"... a voir si il y a un meilleur endroit...
func _process (_delta): # Fonction qui arive à chaques frames du jeu
	if active: # Vérifie si le script est actif
		# Ici, on prend l'input au niveau du clavier ou de la manette (j'y ai passé la journée donc sois impressionné stp...)
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction:
			if not input_before:
				direction = Global.get_sign_vector(direction)

				altern = not altern
				var pos

				# Hard coded... :_(
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

				pos += old_pos
				select_cell(pos)
				input_before = true

		else:
			input_before = false
		
		if Input.is_action_just_pressed("ui_accept"):
			if is_cell_valid(old_pos):
				var send_pos = $Cells.map_to_world(old_pos)
				emit_signal("move", send_pos)
	return


func _input (event):
	if active: #Vérifie si le script est actif
		# Détecte si la souris à changée de position
		if event is InputEventMouseMotion:
			# Sélectionne la case sur laquelle la souris est 
			var pos = event.position + Global.camera_offset - OS.window_size / 2
			if old_mouse_pos.distance_squared_to(pos) > 10:
				var pos_m = $Selection.world_to_map(pos)
				select_cell(pos_m)
				old_mouse_pos = pos
	return
