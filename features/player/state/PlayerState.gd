# PlayerState.gd
extends LimboState
class_name PlayerState


const Player: Script = preload("uid://c2uxhumgng18h")


func get_player() -> Player: return agent as Player
func get_hsm() -> LimboHSM: return get_root() as LimboHSM
func get_current_frame() -> int: return get_player().sprite.frame
func move_and_slide() -> bool: return get_player().move_and_slide()
func is_on_wall() -> bool: return get_player().is_on_wall()
