# map.gd
extends Node2D
class_name Map


const Border: Script = preload("uid://3rtf5smyg7ch")
const Game: Script = preload("uid://8davlql87hbq")


@export_flags("Left:1", "Top:2", "Right:4", "Bottom:8") var opened: int:
	set(value):
		opened = value
@export var map_size: Vector2i = Vector2i(1, 1)
@export var margin: float = 6.


#@export var border: Border


@export var enter_pos: Marker2D
@export var exit_pos: Marker2D


#func _ready() -> void:
	#open()


#func open() -> void:
	#border.set_border(get_map_size(), opened, true)


#func close() -> void:
	#border.set_border(get_map_size(), opened)


func remove_player() -> void:
	remove_child(Global.player)


func add_player() -> void:
	add_child(Global.player)
