# NormalAttack.gd
extends PlayerState

@export var enter_state_key: StringName = &"normal_attack"
@export var idle_state: LimboState

@export var cooltime: float = .5
@export var anim: AnimationPlayer


func _enter_tree() -> void:
	anim.animation_finished.connect(
		func(anim_name: StringName) -> void:
			if anim_name == &"attack":
				get_hsm().change_active_state(idle_state)
	)

func _enter() -> void:
	get_player().input_state.lock()
	anim.play(&"attack")


func _update(delta: float) -> void:
	if Input.is_action_just_pressed("block"):
		get_hsm().dispatch(&"block")



func _exit() -> void:
	get_player().attack_free()
	blackboard.get_var(&"cooltime", {enter_state_key : cooltime})
