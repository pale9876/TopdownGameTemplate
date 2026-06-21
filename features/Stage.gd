extends Node2D


#@export var camera: Camera2D
@export var player_start_spawn_position: Marker2D
@export var exit_enter_position: Marker2D

#func _process(delta: float) -> void:
	#if Global.player:
		#camera.position = Global.player.position
