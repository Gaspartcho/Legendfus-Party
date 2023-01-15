extends Node

# Ici, on vas écrire les fonctions "globales" du jeu: des fonctions générales qui pouront se faires appelés dans d'autres scripts.
# exemple: un fonction whatever() poura etre appelée dans n'importe quel script par global.whatever()
# On vas aussi metre les variables globales


#region Variables

const game_version: String = "LegendFus Party: Prototype 0.1 - Client"

var offline_mode: bool = false

var players: Dictionary = {}
var sbires: Dictionary = {}

var personal_id: int = 1
var username: String = "CloneKnight"

#endregion