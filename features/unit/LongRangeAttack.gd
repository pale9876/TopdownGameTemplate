# long_range_attack.gd
extends UnitState


@export var scene: PackedScene
@export var idle_state: LimboState
@export var anim: AnimationPlayer


func _ready() -> void:
	anim.animation_finished.connect(_anim_finished)


func _enter() -> void:
	pass


func _update(_delta: float) -> void:
	pass


func _anim_finished(anim_name: StringName) -> void:
	if anim_name == &"long_range_attack":
		pass
