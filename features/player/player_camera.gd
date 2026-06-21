# player/player_camera.gd
extends Camera2D


const Zone: Script = preload("uid://dl2h3dk154j54")


var force: Vector2
var time: float


@export var time_scale: float = 3.
var pin: Node2D


func _process(delta: float) -> void:
	if pin:
		global_position = pin.global_position
	
	if time > 0.:
		force = - force
		
		offset = offset.lerp(force, randf_range(.125, .225))
		force = force.lerp(Vector2(), randf_range(.095, .225))
		time = maxf(0., time - (delta * time_scale))


func shake(_force: Vector2, _time: float) -> void:
	force = _force
	time = _time


func pined(target: Node2D) -> void:
	pin = target

func pin_free() -> void:
	pin = null


func limit() -> void:
	pass
