# unit/state/Dead.gd
extends UnitState


func _enter() -> void:
	var unit := get_unit()
	unit.anim.play(&"death")
	


func _exit() -> void:
	printerr(get_unit().name, " => ERROR:: 비정상적인 상태변화 감지")
