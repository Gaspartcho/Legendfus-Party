extends Node2D


#region Variables

#exports variables
export var terrians_costs: Dictionary = {"plain":1, "swamp":2, "mountain_up":2, "mountain_down":1, "forest":2}



#scene objects
onready var obj_map_tilemap: TileMap = $Map_tilemap
onready var obj_selection_tilemap: TileMap = $Selection_tilemap


#others
var map_size: Rect2

#unused variable
var _unused

#endregion

func _ready() -> void:
	map_size = get_map_size()

	return


func get_map_size() -> Rect2:
	# On assume que la carte est rectangulaire et qu'il y a au moins une tile sur (0, 0)
	var pos_u = Vector2(-1, -1)
	var pos_d = Vector2(1, 1)

	while obj_map_tilemap.get_cellv(pos_u) != -1:
		pos_u.x -= 1
	pos_u.x += 1
	while obj_map_tilemap.get_cellv(pos_u) != -1:
		pos_u.y -= 1
	pos_u.y += 1

	while obj_map_tilemap.get_cellv(pos_d) != -1:
		pos_d.x += 1
	pos_d.x -= 1
	while obj_map_tilemap.get_cellv(pos_d) != -1:
		pos_d.y += 1
	pos_d.y -= 1

	return Rect2(pos_u, pos_d)


func create_astar_from_tilemap(area: Rect2 = map_size) -> AStar:
	# The points' coordinates are relative to the tilemap scale
	var this_astar = AStar.new()
	var cell_weight: int
	var n_point_id: int
	var last_point_id: int

	this_astar.reserve_space((area.size.x - area.position.x) * (area.size.y - area.position.y))

	# First point
	last_point_id = this_astar.get_available_point_id()
	cell_weight = get_tile_cost(Vector2(area.position.x, area.position.y))
	this_astar.add_point(last_point_id, Vector3(area.position.x, area.position.y, 0), cell_weight)

	#First row
	for i in range(area.position.x + 1, area.size.x + 1):
		cell_weight = get_tile_cost(Vector2(i, area.position.y))
		n_point_id = this_astar.get_available_point_id()
		this_astar.add_point(n_point_id, Vector3(i, area.position.y, 0), cell_weight)
		this_astar.connect_points(n_point_id, last_point_id)
		last_point_id = n_point_id
	
	for j in range(area.position.y + 1, area.size.y + 1):
		cell_weight = get_tile_cost(Vector2(area.position.x, j))
		last_point_id = this_astar.get_available_point_id()
		this_astar.add_point(last_point_id, Vector3(area.position.x, j, 0), cell_weight)
		this_astar.connect_points(last_point_id, this_astar.get_closest_point(Vector3(area.position.x, j-1, 0)))
		
		for i in range(area.position.x + 1, area.size.x + 1):
			cell_weight = get_tile_cost(Vector2(i, j))
			n_point_id = this_astar.get_available_point_id()
			this_astar.add_point(n_point_id, Vector3(i, j, 0), cell_weight)
			this_astar.connect_points(n_point_id, last_point_id)
			this_astar.connect_points(n_point_id, this_astar.get_closest_point(Vector3(i, j-1, 0)))
			last_point_id = n_point_id

	return this_astar



func get_tile_type(cell: int, _level:int = 0) -> String:
	# Returns the cost of traveling to this type of cell
	if cell == 0:
		return "plain"

	# add more possiblilities the more type of cells there is
	# use "<=" , ">=", or "or" if there is many type of cells for one type of terrain
	
	#returns "none" if haven't found the value
	return "none"


func get_tile_cost(target_pos: Vector2) -> int:
	return terrians_costs[get_tile_type(obj_map_tilemap.get_cellv(target_pos))]

func transpose_map_to_world_array(data: PoolVector2Array) -> PoolVector2Array:
	var final_array = PoolVector2Array()
	for i in data:
		final_array.push_back(obj_map_tilemap.map_to_world(i))
	return final_array

func transpose_world_to_map_array(data: PoolVector2Array) -> PoolVector2Array:
	var final_array = PoolVector2Array()
	for i in data:
		final_array.push_back(obj_map_tilemap.world_to_map(i))
	return final_array


func draw_selection(liste: PoolVector2Array, id: int, scale_top_map: bool = true) -> void:
	if not scale_top_map:
		liste = transpose_world_to_map_array(liste)
	
	for i in liste:
		obj_selection_tilemap.set_cellv(i, id)

	return

func clear_selection() -> void:
	obj_selection_tilemap.clear()
	
	return
