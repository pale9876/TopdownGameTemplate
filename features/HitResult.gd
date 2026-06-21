# hit_result.gd
extends RefCounted
class_name HitResult


enum Type {
	NONE,
	KNOCKBACK,
	STUN,
}

var skill_name: StringName = &""
var from: Node2D
var damage: int
var force: float
var af_time: float

func _init(_from: Node2D, _dmg: int, _force: float, _af_time: float) -> void:
	from = _from
	damage = _dmg
	force = _force
	af_time = _af_time
