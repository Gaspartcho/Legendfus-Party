extends Node2D


var valid_cells = [0] # Liste des indices de la tileSet qui sont valides (on peut marcher ou attaquer dessus)

var reach_cells = PoolVector2Array() # Liste des positions sur léquelles le perso peut effecturer ses actions (en fonctions de ses capacités à lui)

var old_pos = Vector2()


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
	$Selection.set_cell(pos.x, pos.y, is_cell_valid(pos))

	$Selection.set_cell(old_pos, -1)
	return