# player/Move.gd
extends PlayerState


const FOOT_STEP: AudioStream = preload("uid://5vywoue6uxna")


# Import
const NormalAttack: Script = preload("uid://cihrgym0j2jwa")
const StateMachine: Script = preload("uid://dk3e44xymq6vj")


@export var idle_state: LimboState
@export var normal_attack_state: NormalAttack
@export var sprite: AnimatedSprite2D


var _step: int = 3


func _ready() -> void:
	sprite.frame_changed.connect(on_frame_changed)


func _enter() -> void:
	var player: Player = get_player()
	var new_suffix: StringName = player.get_anim_suffix(player.input_state.direction)
	if new_suffix != blackboard.get_var(&"anim_suffix"):
		blackboard.set_var(&"anim_suffix", new_suffix)
	player.sprite.play(&"move" + new_suffix)


func _update(delta: float) -> void:
	var player := get_player()
	
	if player.input_state.direction == Vector2():
		get_hsm().change_active_state(idle_state)
		return
	
	if Input.is_action_just_pressed(&"attack"):
		if get_hsm().dispatch(StateMachine.EV_ATTACK):
			return
	
	if Input.is_action_pressed(&"block"):
		if get_hsm().dispatch(StateMachine.EV_BLOCK):
			return

	var input_dir: Vector2 = player.input_state.direction
	var motion: Vector2 = player.stat.speed * input_dir
	player.state.face = Vector2i(input_dir.round())
	player.velocity = motion
	
	# Set Anim Direction
	var new_suffix: StringName = player.get_anim_suffix(input_dir)
	if (blackboard.get_var(&"anim_suffix") as StringName) != new_suffix:
		player.sprite.play(&"move" + new_suffix)
		blackboard.set_var(&"anim_suffix", new_suffix)
	
	# PointResult
	var point_param: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	point_param.collision_mask = 1
	point_param.collide_with_areas = true
	point_param.position = player.global_position
	point_param.exclude = [ player.get_rid() ]
	
	var result: Array[Dictionary] = player.get_world_2d().direct_space_state.intersect_point( point_param, 1 )
	if !result.is_empty():
		print(result)
	
	move_and_slide()


func on_frame_changed() -> void:
	var current_frame: int = get_current_frame()
	var channel := Global.get_channel()
	
	if get_hsm().get_active_state() == self:
		_step -= 1
		if _step == 0:
			channel.play(
				get_player().global_position,
				FOOT_STEP
			)
			_step = 3



func _exit() -> void:
	var unit: Player = agent as Player
	unit.velocity = Vector2()
