extends UnitState


# Import
const MinionAttackState: Script = preload("uid://cpx0m44vhyoyu")
const UnitStateMachine: Script = preload("uid://dyahyd1lku8rp")


@export var idle_state: UnitState
@export var attack_state: MinionAttackState

@export var tolorance: float = 10.


func _update(_delta: float) -> void:
	var unit := get_unit()
	
	if unit.target == null:
		get_hsm().change_active_state(idle_state)
		return
	
	var speed:= unit.stat.speed
	var direction: Vector2 = unit.global_position.direction_to(
		unit.target.global_position
	)
	unit.velocity = direction * speed
	
	unit.move_and_slide()
	
	if unit.target.global_position.distance_to(unit.global_position) < tolorance:
		var payload: Dictionary = { "direction" : direction }
		get_hsm().dispatch(
			UnitStateMachine.EV_ATTACK,
			payload
		)


func _exit() -> void:
	var unit := get_unit()
	unit.velocity = Vector2()
