extends UnitState


@export var chase_state: UnitState


func _enter() -> void:
	var unit:= get_unit()
	unit.anim.play(&"idle")


func _update(delta: float) -> void:
	var unit := get_unit()

	if unit.target and !unit.target_is_neutralized():
		get_hsm().change_active_state(chase_state)
