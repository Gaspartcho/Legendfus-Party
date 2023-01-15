extends Node2D


#region Variables

#exports variables
#Using dictionaries for attacks, waiting to be able to export the custom classes
export var character_name: String = "Default"
export var life: int = 10
export var shield: int = 5
export var movement_speed: int = 5

export var attack_1: Resource
export var attack_2: Resource
export var attack_3: Resource
export var attact_4: Resource
export var attack_u: Resource


#scene objects
onready var obj_username_label: Label = $Username_label


#others
onready var attacks: Array = [attack_1, attack_2, attack_3, attact_4, attack_u]
var team: String


#unused variable
var _unused

#endregion


func set_info(data: Dictionary) -> void:
    obj_username_label.text = data["username"]
    team = data["team"]
    

    return