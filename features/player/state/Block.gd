# Shield.gd
extends PlayerState

# Import
const StateMachine: Script = preload("uid://dk3e44xymq6vj")

@export var enter_state_key: StringName = &"block"
@export var idle_state: LimboState
@export var anim: AnimationPlayer
@export var cooldown: float = .5

@export var just_input_time: float = .35
var _just: float = 0.
var cleaned: bool = false


func _ready() -> void:
	anim.animation_finished.connect(_animation_finished)


func _enter() -> void:
	var unit: Player = get_player()
	unit.input_state.lock()
	
	if anim.current_animation == &"attack":
		unit.attack_free()
	
	anim.play(&"block")
	print("block")
	
	_just = just_input_time


func _update(delta: float) -> void:
	if Input.is_action_just_pressed(&"attack"):
		if get_hsm().dispatch(&"attack"):
			return

	if !Input.is_action_pressed(&"block") and anim.current_animation == &"block":
		anim.play(&"block_free")
		return

	if anim.current_animation == &"block":
		_just = maxf(0., _just - delta)


func _exit() -> void:
	get_player().block_free()
	cleaned = false


func _animation_finished(anim_name: StringName) -> void:
	if anim_name == "block_free":
		var hsm := get_hsm()
		hsm.dispatch(StateMachine.REVERT)
		get_player().block_free()
		print("Block Freed")
