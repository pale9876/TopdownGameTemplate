# unit/hurtbox.gd
extends Area2D


const Unit: Script = preload("uid://bl84ixx4kubfe")


func _init() -> void:
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(2, true)


func damaged(hit_result: HitResult) -> void:
	var stat := get_stat()
	var unit := get_unit()
	
	stat.hp -= hit_result.damage
	stat.damaged.emit()

	if stat.hp > 0:
		unit.knockbacked(hit_result)


func get_unit() -> Unit: return get_parent() as Unit
func get_stat() -> Unit.Stat: return get_unit().stat
