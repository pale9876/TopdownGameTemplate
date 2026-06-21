# player/StateMachine.gd
extends LimboHSM

# IMPORT
const Player: Script = preload("uid://c2uxhumgng18h")
const BlockState: Script = preload("uid://b2uj66sicjd5p")
const NormalAttackState: Script = preload("uid://cihrgym0j2jwa")


# EVENT
const REVERT: StringName = &"revert"
const EV_ATTACK: StringName = &"attack"
const EV_BLOCK: StringName = &"block"
const EV_KNOCKBACK: StringName = &"knockback"
const EV_DEATH: StringName = &"death"


# Always States
@export var idle_state: LimboState
@export var death_state: LimboState
@export var knockback_state: LimboState
@export var block_state: BlockState
@export var normal_attack_state: NormalAttackState


func on_enter() -> void:
	var unit: Player = get_parent() as Player
	
	add_transition(
		ANYSTATE, idle_state, &"revert"
	)
	
	add_transition(
		ANYSTATE, knockback_state, &"knockback"
	)
	
	add_transition(
		ANYSTATE, normal_attack_state, &"attack",
		func() -> bool:
			return enable(normal_attack_state)
	)

	add_transition(
		ANYSTATE, block_state, &"block",
		func() -> bool:
			return enable(block_state)
	)
	
	add_transition(
		ANYSTATE, death_state, EV_DEATH
	)


func _process(delta: float) -> void:
	var current_cooltime_data := blackboard.get_var(&"cooltime") as Dictionary
	
	for key: StringName in current_cooltime_data:
		var _cooltime := current_cooltime_data[key] as float
		if _cooltime > 0.:
			current_cooltime_data[key] = maxf(0., _cooltime - delta)
			if current_cooltime_data[key] == 0.:
				pass


func get_player() -> Player:
	return agent as Player


func get_cooltime_data() -> Dictionary:
	return blackboard.get_var(&"cooltime") as Dictionary


func enable(state: PlayerState) -> bool:
	var cooltime_data: Dictionary = get_cooltime_data()
	var _state_enable: bool = !cooltime_data.has(state.enter_state_key) or cooltime_data[state.enter_state_key] == 0.
	var has_neutralized: bool = get_active_state() in [knockback_state, death_state]
	
	if !has_neutralized and _state_enable:
		return true
	return false


func entry_enable(condition: Callable, state: PlayerState, execute_immidiatly: bool = false) -> bool:
	var result: bool = condition.call() as bool
	if execute_immidiatly:
		change_active_state(state)
	return result
