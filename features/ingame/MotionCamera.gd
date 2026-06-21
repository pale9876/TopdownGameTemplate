# motion_camera.gd

extends Camera2D


func _init() -> void:
	limit_enabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if target:
		#global_position = target.global_position


# x: left, y: top, z: right, w: bottom
func limitation(left: int, top: int, right: int, bottom: int) -> void:
	set_limit(SIDE_LEFT, left)
	set_limit(SIDE_TOP, top)
	set_limit(SIDE_RIGHT, right)
	set_limit(SIDE_BOTTOM, bottom)
