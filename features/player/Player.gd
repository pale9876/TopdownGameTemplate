# player.gd
extends CharacterBody2D


# Import
const StateMachine: Script = preload("uid://dk3e44xymq6vj")
const Sprite: Script = preload("uid://ca4mkn8u6cnys")
const PlayerHitbox: Script = preload("uid://0dw4edo0eshv")
const PlayerHurtbox: Script = preload("uid://er84buu2gymf")
const PlayerCamera: Script = preload("uid://djt8ls4mcqxhm")


@export var info: PlayerInformation
@export var limbo_hsm: StateMachine
@export var forms: Array[Node2D]


var input_state: InputState = InputState.new()
var stat: Stat = Stat.new()
var state: State = State.new()


var suffix: StringName = &"_down"
var action: StringName = &"idle"


@onready var sprite: Sprite = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hitbox: PlayerHitbox = $Hitbox
@onready var hurtbox: PlayerHurtbox = $Hurtbox
@onready var player_camera: PlayerCamera = $PlayerCamera


func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	set_collision_mask_value(1, true)
	#set_collision_mask_value(2, true)
	stat.dead.connect(_on_death)


func _enter_tree() -> void:
	GSignal.soft_pause.connect(_soft_paused)
	GSignal.resume.connect(_resume)
	Global.channel.target = self


func _ready() -> void:
	if info:
		stat.name = name
		stat.max_hp = info.hp
		stat.hp = stat.max_hp
		stat.speed = info.speed
		
		sprite.sprite_frames = info.sprite
		sprite.play(&"idle_down")

	limbo_hsm.blackboard.set_var(&"anim_suffix", &"_down")

	limbo_hsm.initialize(self)
	limbo_hsm.set_active(true)
	limbo_hsm.on_enter()


func _exit_tree() -> void:
	GSignal.soft_pause.disconnect(_soft_paused)
	GSignal.resume.disconnect(_resume)


func _soft_paused() -> void:
	set_process(false)
	set_physics_process(false)
	input_state.lock()
	limbo_hsm.set_active(false)
	sprite.pause()


func _resume() -> void:
	set_process(true)
	set_physics_process(true)
	input_state.unlock()
	limbo_hsm.set_active(true)
	sprite.play(sprite.animation)


func _physics_process(_delta: float) -> void:
	input_state.direction = Input.get_vector("left", "right", "up", "down").normalized()


func get_anim_suffix(motion: Vector2) -> StringName:
	var normalized: Vector2 = motion.normalized() if !motion.is_normalized() else motion
	
	var x_dir: int = roundi(normalized.x)
	var y_dir: int = roundi(normalized.y)
	
	var x_str: StringName = &"_left" if x_dir < 0 else &"_right" if x_dir > 0 else &""
	var y_str: StringName = &"_down" if y_dir > 0 else &"_up" if y_dir < 0 else &""
	
	var result: StringName = x_str + y_str
	if !(x_str.is_empty() and y_str.is_empty()): suffix = result
	
	return result


func knockbacked(motion: Vector2, duration: float) -> void:
	limbo_hsm.dispatch(
		limbo_hsm.EV_KNOCKBACK,
		{"force" : motion, "duration" : duration}
	)


func attack_free() -> void:
	hitbox.hide()
	input_state.unlock()

	for node: Node in hitbox.get_children():
		if node is HitboxShape and !node.disabled:
			node.disabled = true

	limbo_hsm.blackboard.set_var(
		&"cooltime", {
			limbo_hsm.normal_attack_state.enter_state_key : limbo_hsm.normal_attack_state.cooltime
		}
	)

func block_free() -> void:
	input_state.unlock()
	hurtbox.is_guarding = false
	
	limbo_hsm.blackboard.set_var(
		&"cooltime", {
			limbo_hsm.block_state.enter_state_key : limbo_hsm.block_state.cooldown
		}
	)


func _on_death() -> void:
	anim.play(&"death")
	limbo_hsm.dispatch(StateMachine.EV_DEATH)
	await get_tree().create_timer(2.).timeout
	GSignal.game_over.emit()


class Stat:
	signal damaged()
	signal healed()
	signal dead()
	
	var name: StringName = &""
	var level: int = 0
	var hp: int:
		set(value):
			hp = maxi(0, value)
			if hp == 0:
				dead.emit()
	var max_hp: int
	var speed: float
	var position: Vector2


class State:
	signal face_changed(value: Vector2i)
	
	var face: Vector2i = Vector2i.DOWN:
		set(value):
			if value != face:
				face = value
				if value != Vector2i.ZERO:
					face_changed.emit(value)
	
	var _neutralized: bool = false
	var reserve: int = -1


	func is_neutralized() -> bool: return _neutralized

	func neutralized() -> void:
		# TODO
		_neutralized = true


class InputState:
	var direction: Vector2 = Vector2.ZERO:
		set(value):
			if !locked(): direction = value
	#var reserve_action: String
	#var order_duration: float = - 1.
	var _lock: bool = false

	func lock() -> void:
		_lock = true
	
	func unlock() -> void:
		_lock = false

	func locked() -> bool: return _lock
