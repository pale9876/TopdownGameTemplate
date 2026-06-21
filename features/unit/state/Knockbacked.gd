extends UnitState


var forced: Vector2
var duration: float = 0.


func _enter() -> void:
	var unit := get_unit()
	var data := get_hsm().blackboard.get_var(&"hit") as Dictionary
	
	var _knockback_force := data["force"] as Vector2
	var _duration := data["duration"] as float

	forced = _knockback_force
	duration = _duration
	
	unit.anim.play(&"knockbacked")
	unit.effect_player.play(&"hurt")
	


func _update(delta: float) -> void:
	duration = maxf(duration - delta, 0.)
	
	var unit := get_unit()
	
	unit.velocity = forced
	forced = forced.move_toward(Vector2(), 20.)
	unit.move_and_slide()
	
	if duration == 0.:
		get_hsm().dispatch(&"revert")
		print("Revert")
		return

func _exit() -> void:
	get_unit().effect_player.play(&"RESET")
