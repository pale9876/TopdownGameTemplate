# Door.gd
extends Area2D


const Player: Script = preload("uid://c2uxhumgng18h")


@export_file("scene") var link: String


func _init() -> void:
	body_entered.connect(_entered)


func _entered(body: Node2D) -> void:
	if body is Player and !link.is_empty():
		Global.get_ingame()
