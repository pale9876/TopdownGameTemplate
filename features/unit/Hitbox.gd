# unit/hitbox.gd
extends Area2D


const Unit: Script = preload("uid://bl84ixx4kubfe")
const PlayerHurtbox: Script = preload("uid://er84buu2gymf")


func _init() -> void:
	monitoring = true
	monitorable = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_mask_value(2, true)


func _enter_tree() -> void:
	area_shape_entered.connect(entered)


func entered(
	area_rid: RID,
	area: Area2D,
	area_shape_index: int,
	local_shape_index: int
) -> void:
	
	if area is PlayerHurtbox:
		var hb_info: HitboxInformation = (get_child(local_shape_index) as HitboxShape).hitbox_info
		var hit_result: HitResult = HitResult.new(
			get_parent() as Unit,
			hb_info.damage, hb_info.force, .25
		)
		
		hit_result.from = get_parent() as Unit
		area.damaged(hit_result)
		
