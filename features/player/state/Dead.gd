# Dead.gd
extends PlayerState


func _enter() -> void:
	var player := get_player()
	
	player.input_state.lock()
	player.state.neutralized()
	player.anim.play(&"death")


func _exit() -> void:
	printerr("Error => 비정상적인 상태 흐름")
