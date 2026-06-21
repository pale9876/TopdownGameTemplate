extends Node


const PLAYER_HEAL_OBJECT: PackedScene = preload("uid://bp4pdps0ifeeh")


var item_list: Dictionary[PackedScene, Dictionary] = {
	PLAYER_HEAL_OBJECT : {
		"probability" : .2,
	}
}


func get_dynamic_prob() -> float:
	return 0.
