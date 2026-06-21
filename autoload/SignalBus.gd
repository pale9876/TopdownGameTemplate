extends Node

# Game
signal start()
signal open_settings()
signal game_over()


# Soft Paused
signal soft_pause()
signal resume()


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
