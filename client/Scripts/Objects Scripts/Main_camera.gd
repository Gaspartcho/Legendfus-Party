extends Camera2D


#region Variables

#exports variables
export var camera_speed: float = 1
export var camera_friction: float = 1.3
export var camera_zoom_speed: float = 1.07
export var zoom_limits: Dictionary = {"min": 0.25, "max": 4.0}


#scene objects


#others
onready var vp_size: Vector2 = get_viewport().size
var camera_momentum: Vector2 = Vector2(0, 0)
var cam_zoom_offset: float = 1 - 1 / camera_zoom_speed
var cam_unzoom_offset: float = 1 - camera_zoom_speed


#unused variable
var _unused

#endregion


func _process(delta) -> void:
	var m_pos = get_viewport().get_mouse_position()
	var has_moved = false

	if m_pos.x <= 0:
		camera_momentum.x = -camera_speed
		has_moved = true
	if m_pos.y <= 0:
		camera_momentum.y = -camera_speed
		has_moved = true
	if m_pos.x >= vp_size.x - 1:
		camera_momentum.x = camera_speed
		has_moved = true
	if m_pos.y >= vp_size.y - 1:
		camera_momentum.y = camera_speed
		has_moved = true
	
	if not has_moved:
		if camera_momentum.x < 1 and camera_momentum.x > -1 and camera_momentum.x != 0:
			camera_momentum.x = 0
		elif camera_momentum.y < 1 and camera_momentum.y > -1 and camera_momentum.y != 0:
			camera_momentum.y = 0
		else:
			camera_momentum /= camera_friction

	position += camera_momentum * zoom * delta
	
	if Input.is_action_just_released("map_zoom") and zoom.x > zoom_limits["min"]:
		position += (m_pos - vp_size / 2) * cam_zoom_offset * zoom.x
		zoom /= camera_zoom_speed

	if Input.is_action_just_released("map_unzoom") and zoom.x < zoom_limits["max"]:
		position += (m_pos - vp_size / 2) * cam_unzoom_offset * zoom.x
		zoom *= camera_zoom_speed

	if Input.is_action_just_pressed("camera_reset"):
		position = get_node("../Players/" + str(Global.personal_id)).position
		zoom = Vector2(1, 1)

	
	return
