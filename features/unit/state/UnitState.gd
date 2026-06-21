# UnitState.gd
extends LimboState
class_name UnitState


const Unit: Script = preload("uid://bl84ixx4kubfe")


func get_unit() -> Unit: return agent as Unit
func get_stat() -> Unit.Stat: return get_unit().stat
func get_hsm() -> LimboHSM: return get_root() as LimboHSM
