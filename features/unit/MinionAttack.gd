# MinionAttack.gd
extends UnitState


@export var chase_state: UnitState

@export var anim: AnimationPlayer
@export var attack_range: float = 10.
@export var cooldown: float = 1.
@export var angle_tolorance: float = 90.

@export var hitbox_shape: HitboxShape


var _direction: Vector2 = Vector2()


func _ready() -> void:
	anim.animation_finished.connect(_animation_finished)


func _enter() -> void:
	var cargo := get_cargo() as Dictionary
	var direction: Vector2 = cargo["direction"] as Vector2
	_direction = direction
	
	var unit := get_unit()
	
	hitbox_shape.global_position = unit.global_position + (
		_direction * attack_range
	)
	anim.play(&"attack")


func _update(_delta: float) -> void:
	var unit := get_unit()
	
	if unit.target:
		var _max_angle: float = _direction.angle() + deg_to_rad(angle_tolorance)
		var _min_angle: float = _direction.angle() - deg_to_rad(angle_tolorance)
		var target_direction: Vector2 = unit.global_position.direction_to(unit.target.global_position)
		var current_dir: float = clampf(target_direction.angle(), _min_angle, _max_angle)
		hitbox_shape.global_position = unit.global_position + (Vector2.from_angle(current_dir) * attack_range)


func _animation_finished(anim_name: StringName) -> void:
	if anim_name == &"attack":
		var unit := get_unit()
		if !unit.target_is_neutralized():
			get_hsm().change_active_state(chase_state)


func freed() -> void:
	pass
