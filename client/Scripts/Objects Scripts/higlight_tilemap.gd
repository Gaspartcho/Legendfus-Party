extends TileMap


#region Variables

#exports variables


#scene objects

#others


#unused variable
var _unused

#endregion


func fill_area(area: PoolVector3Array, cell_type: int = 0) -> void:
	for this_point in area:
		set_cell(this_point.x + (this_point.y - (int(this_point.y) & 1)) / 2, this_point.y, cell_type)
	return