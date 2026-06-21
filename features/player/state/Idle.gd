# Idle.gd
extends PlayerState


# Import Self
const NormalAttack: Script = preload("uid://cihrgym0j2jwa")
const StateMachine: Script = preload("uid://dk3e44xymq6vj")


# States
@export var move_state: LimboState
@export var normal_attack_state: NormalAttack


func _enter() -> void:
	var unit: Player = get_player()
	var suffix: StringName = blackboard.get_var(&"anim_suffix") as StringName
	unit.sprite.play(&"idle" + suffix)


func _update(_delta: float) -> void:
	var unit: Player = get_player()
	
	if Input.is_action_just_pressed(&"attack"):
		if get_hsm().dispatch(StateMachine.EV_ATTACK):
			return
	
	if Input.is_action_pressed(&"block"):
		if get_hsm().dispatch(StateMachine.EV_BLOCK):
			return
	
	if unit.input_state.direction != Vector2():
		get_hsm().change_active_state(move_state)
		return
