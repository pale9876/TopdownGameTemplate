# NPC.gd
extends CharacterBody2D


@export var dialog_data: Dictionary[String, SproutyDialogsDialogueData] = {}



func _init() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	set_collision_mask_value(1, false)
	set_collision_layer_value(1, false)

	#set_collision_mask_value(2, true)
	set_collision_layer_value(2, true)
