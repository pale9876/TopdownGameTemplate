# Enemy.gd
extends CharacterBody2D
class_name Enemy


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const MinionHitbox: Script = preload("uid://cdpmo1dhtm3s5")
const StateMachine: Script = preload("uid://dyahyd1lku8rp")


@export var information: UnitInformation


@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var hsm: StateMachine = $UnitStateMachine
@onready var effect_player: AnimationPlayer = $Sprite2D/EffectPlayer


var stat: Stat = Stat.new()
var state: State = State.new()
var target: Node2D = null


@onready var hitbox: MinionHitbox = $Hitbox
@onready var hurtbox: Area2D = $Hurtbox


func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	#layer init
	set_collision_layer_value(1, false)
	
	# mask init
	set_collision_mask_value(1, true)
	
	stat.dead.connect(_on_dead)


func _on_dead() -> void:
	hsm.dispatch(StateMachine.EV_DEATH)
	
	hurtbox.monitoring = false
	hitbox.monitoring = false


func _enter_tree() -> void:
	GSignal.soft_pause.connect(_soft_paused)
	GSignal.resume.connect(_resume)

	# init hp
	stat.max_hp = information.hp
	stat.hp = stat.max_hp
	stat.speed = information.speed


func _ready() -> void:
	#agent.navigation_finished.connect(_agent_navigation_finished)
	#agent.velocity_computed.connect(_agent_velocity_computed)
	
	hsm.initialize(self)
	hsm.set_active(true)
	
	set_target(Global.player)


func _exit_tree() -> void:
	GSignal.soft_pause.disconnect(_soft_paused)
	GSignal.resume.disconnect(_resume)


func set_target(node: Node2D) -> void:
	target = node


func _soft_paused() -> void:
	set_process(false)
	set_physics_process(false)
	hsm.set_active(false)
	anim.pause()


func _resume() -> void:
	set_process(true)
	set_physics_process(true)
	hsm.set_active(true)
	anim.play(anim.current_animation)


func knockbacked(hit_result: HitResult) -> void:
	var dir_from_target: Vector2 = hit_result.from.global_position.direction_to(global_position)
	
	var payload: Dictionary[String, Variant] = {
		"force": hit_result.force * dir_from_target,
		"duration": hit_result.af_time
	}
	
	hsm.blackboard.set_var(&"hit", payload)
	hsm.change_active_state(hsm.knockback_state)


func target_is_neutralized() -> bool:
	return (target as Player).state.is_neutralized()


#func _agent_velocity_computed(_safe: Vector2) -> void:
	#pass
#
#
#func _agent_navigation_finished() -> void:
	#pass
#
#
#func _refresh_path() -> void:
	#pass


class Stat:
	signal damaged()
	signal dead()
	
	var max_hp: int
	var hp: int:
		set(value):
			hp = maxi(0, value)
			if hp == 0:
				dead.emit()
	var speed: float


class State:
	var face: int = -1
