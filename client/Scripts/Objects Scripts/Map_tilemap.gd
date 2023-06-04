extends TileMap


#region Variables

#exports variables

export var terrians_costs: Dictionary = {"plain":1, "swamp":2, "mountain_up":2, "mountain_down":1, "forest":2}
export var hex_dirrections: PoolVector3Array

export var generate_new_map: bool = false
export var map_size: int = 10



#scene objects

#others


#unused variable
var _unused

#endregion


func get_point_neighbor(point: Vector3, dir: int) -> Vector3:
    var vec_dir: Vector3 = hex_dirrections[dir]
    return Vector3(point.x + vec_dir.x, point.y + vec_dir.y, point.z + vec_dir.z)


func generate_map() -> void:

	
	return


func generate_astar(start_pos: Vector3 = Vector3()) -> AStar:
	#basicly a bloodfill algorithm
	var n_astar = AStar.new()
	n_astar.reserve_space(get_used_cells().size())

	n_astar.add_point(0, start_pos)
	var just_explored := PoolIntArray()
	var last_explored: PoolIntArray
	just_explored.append(0)

	var this_point: Vector3
	var neighbor_pos: Vector3
	var neighbor_id: int
	var current_cell: int

	while not just_explored.empty():
		last_explored = just_explored
		just_explored = PoolIntArray()

		for this_id in last_explored:
			this_point = n_astar.get_point_position(this_id)
			for dir in range(6):
				neighbor_pos = get_point_neighbor(this_point, dir)
				current_cell = get_cell(int(neighbor_pos.x + (neighbor_pos.y - (int(neighbor_pos.y) & 1)) / 2), int(neighbor_pos.y))
				if current_cell in [INVALID_CELL, 0]:
					continue

				neighbor_id = n_astar.get_closest_point(neighbor_pos)

				if neighbor_pos != n_astar.get_point_position(neighbor_id):
					neighbor_id = n_astar.get_available_point_id()
					n_astar.add_point(neighbor_id, neighbor_pos)
					n_astar.connect_points(this_id, neighbor_id)
					just_explored.append(neighbor_id)
				
				elif not n_astar.are_points_connected(this_id, neighbor_id):
					n_astar.connect_points(this_id, neighbor_id)

	return n_astar


