extends Node

# Ici, on vas écrire les fonctions "globales" du jeu: des fonctions générales qui pouront se faires appelés dans d'autres scripts.
# exemple: un fonction whatever() poura etre appelée dans n'importe quel script par global.whatever()
# On vas aussi metre les variables globales (non d'uttilisateur, points de vies, etc...)


#region Variables


var map_array
var players_pos = []


#endregions

#region Fonctions


func get_sign_vector(vec):
	# Renvoie le vecteur avec ses éléments mis au signe (1 si > 0, -1 si < 0, 0 si = 0)
	vec.x = sign(vec.x)
	vec.y = sign(vec.y)
	return vec


#endregion