# player_ui.gd
extends Control


@onready var hp: ProgressBar = %Hp


func _init() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
