extends LimboHSM


# EVENTS
const EV_ATTACK: StringName = &"attack"
const EV_REVERT: StringName = &"revert"
const EV_KNOCKBACK: StringName = &"knockback"
const EV_DEATH: StringName = &"death"


# States
@export var idle_state: UnitState
@export var chase_state: UnitState
@export var attack_state: UnitState
@export var knockback_state: UnitState
@export var dead_state: UnitState


func _ready() -> void:
	add_transition(
		ANYSTATE, knockback_state, EV_KNOCKBACK
	)
	
	add_transition(
		ANYSTATE, idle_state, EV_REVERT
	)
	
	add_transition(
		chase_state, attack_state, EV_ATTACK
	)

	add_transition(
		ANYSTATE, dead_state, EV_DEATH
	)
