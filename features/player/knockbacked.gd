# Knockbacked.gd
extends PlayerState


# Import
const IdleState: Script = preload("uid://clohors1yh30")


@export var idle_state: IdleState
@export var duration: float = 0.
@export var peak: float = .211

var motion: Vector2 = Vector2()


func _enter() -> void:
	var result := get_cargo() as Dictionary
	var player := get_player()
	
	duration = result["duration"] as float
	motion = result["force"] as Vector2
	
	player.velocity = motion
	get_player().sprite.blink_effect_player.play(&"blink")


func _update(delta: float) -> void:
	duration = maxf(0., duration - delta)
	
	var player := get_player()
	
	player.velocity = player.velocity.move_toward(Vector2(), 1250. * delta)
	player.move_and_slide()
	
	if duration == 0.:
		get_hsm().dispatch(&"revert")
		return


func _exit() -> void:
	var player := get_player()
	player.sprite.blink_effect_player.play(&"RESET")
	get_hsm().blackboard.set_var(&"hit", {})
