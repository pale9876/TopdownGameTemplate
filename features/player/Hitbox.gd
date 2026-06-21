# player/hitbox.gd
extends Area2D


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const Hurtbox: Script = preload("uid://bupj3hlvtt67s")


func _init() -> void:
	monitoring = true
	monitorable = false
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	


func _enter_tree() -> void:
	area_shape_entered.connect(_entered)
	
	var unit: Player = get_parent() as Player
	unit.state.face_changed.connect(
		func(value: Vector2i) -> void:
			rotation = Vector2(value).angle()
	)
	
	


func _exit_tree() -> void:
	area_shape_entered.disconnect(_entered)


func _entered(
	rid: RID,
	area: Area2D,
	area_idx: int,
	local_idx: int
) -> void:
	if area is Hurtbox:
		var hit_info: HitboxInformation = (get_child(local_idx) as HitboxShape).hitbox_info
		var hit_result := HitResult.new(
			get_parent() as Node, hit_info.damage, hit_info.force, 1.
		)
		area.damaged(hit_result)
		print("Player Hit Enemy => damage: {%s}" % hit_info.damage)
