extends Node

# Ici, on vas écrire les fonctions "globales" du jeu: des fonctions générales qui pouront se faires appelés dans d'autres scripts.
# exemple: un fonction whatever() poura etre appelée dans n'importe quel script par global.whatever()
# On vas aussi metre les variables globales


#region Variables

var camera_offset:Vector2

var server_port = 25566
var server_info = {"name":"", "ip":[], "port":0, "max_players":10, "nb_players":0}


var player_info = {}
var my_info = {"name":"", "ip":[], "character":"default"}


#endregions

#region Fonctions


func get_sign_vector(vec:Vector2) -> Vector2:
	# Renvoie le vecteur avec ses éléments mis au signe (1 si > 0, -1 si < 0, 0 si = 0)
	vec.x = sign(vec.x)
	vec.y = sign(vec.y)
	return vec


func get_character(name:String) -> Node2D:
	if name == "default" or name == "Default":
		return load("res://Objects/Characters/Default_player.tscn").instance()
	return load("res://Objects/Characters/" + name + ".tscn").instance()

#endregion