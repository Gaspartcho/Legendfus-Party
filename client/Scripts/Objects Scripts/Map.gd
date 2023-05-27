extends Node2D


#region Variables

#exports variables
export var terrians_costs: Dictionary = {"plain":1, "swamp":2, "mountain_up":2, "mountain_down":1, "forest":2}



#scene objects
onready var obj_map_tilemap: TileMap = $Map_tilemap

#others
var map_size: Rect2

#unused variable
var _unused

#endregion

