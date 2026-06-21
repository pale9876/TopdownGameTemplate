# hud.gd
extends CanvasLayer


# Import
const DialogUI: Script = preload("uid://borjea45xky04")
const PlayerUI: Script = preload("uid://du3jilcytfh0y")


@onready var player_ui: PlayerUI = %PlayerUI
@onready var dialog_ui: DialogUI = %DialogUI


func _ready() -> void:
	player_ui.show()
	dialog_ui.hide()
	
	Global.player.stat.damaged.connect(_player_damaged)
	Global.player.stat.healed.connect(_player_healed)


func _player_damaged() -> void:
	var player := Global.player
	var progress: float = float(player.stat.hp) / float(player.stat.max_hp)
	var tween: Tween = create_tween()
	tween.tween_property(
		player_ui.hp, "value", progress, .5
	)


func _player_healed() -> void:
	var player:= Global.player
	var progress: float = float(player.stat.hp) / float(player.stat.max_hp)
	var tween: Tween = create_tween()
	tween.tween_property(
		player_ui.hp, "value", progress, .5
	)
