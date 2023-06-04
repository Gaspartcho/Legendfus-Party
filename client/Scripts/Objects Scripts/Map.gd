extends Node2D


signal console_log (message)


#region Variables

#exports variables


#scene objects
onready var obj_map_tilemap: TileMap = $Map_tilemap
onready var obj_highlight_tilemap: TileMap = $Higlight_tilemap

#others
var pathfinder: AStar

#unused variable
var _unused

#endregion


func _ready() -> void:
	pathfinder = obj_map_tilemap.generate_astar()

	return


func occupy_position(pos: Vector3, is_occupied: bool = true) -> void:
	pathfinder.set_point_disabled(pathfinder.get_closest_point(pos, true), is_occupied)
	return

func compute_path(from: Vector2, to: Vector2, highlight: bool = false, max_dist: int = 0) -> PoolVector2Array:
	var point_from: int = pathfinder.get_closest_point(grid_to_hex(from, false), true)
	var point_to: int = pathfinder.get_closest_point(grid_to_hex(to, false))
	var path = pathfinder.get_point_path(point_from, point_to)
	var unable_path := PoolVector3Array()
	var path_length: int = path.size()
	if path_length > max_dist and max_dist > 0:
		var n_path := PoolVector3Array()
		for i in range(max_dist + 1, path_length):
			unable_path.append(path[i])
		for i in range(max_dist + 1):
			n_path.append(path[i])
		path = n_path


	obj_highlight_tilemap.clear()
	if highlight:
		obj_highlight_tilemap.fill_area(path, 0)
		obj_highlight_tilemap.fill_area(unable_path, 1)


	return hex_to_grid_array(path, false)



func grid_to_hex(pos: Vector2, on_scale: bool = true) -> Vector3:
	if not on_scale:
		pos = obj_map_tilemap.world_to_map(pos)

	var new_x = pos.x - (pos.y - (int(pos.y) & 1)) / 2
	return Vector3(new_x, pos.y, -new_x -pos.y)

func hex_to_grid(pos: Vector3, on_scale: bool = true) -> Vector2:
	var u_pos = Vector2(pos.x + (pos.y - (int(pos.y) & 1)) / 2, pos.y)

	if on_scale:
		return u_pos
	else:
		return obj_map_tilemap.map_to_world(u_pos) + (obj_map_tilemap.cell_size / 2).round()


func grid_to_hex_array(list: PoolVector2Array, on_scale: bool = true) -> PoolVector3Array:
	var array_list = PoolVector3Array()
	for this_array in list:
		array_list.append(grid_to_hex(this_array, on_scale))
	return array_list

func hex_to_grid_array(list: PoolVector3Array, on_scale: bool = true) -> PoolVector2Array:
	var array_list = PoolVector2Array()
	for this_array in list:
		array_list.append(hex_to_grid(this_array, on_scale))
	return array_list


func distance_to(a: Vector3, b: Vector3 = Vector3()) -> int:
	return int((abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)) / 2)
