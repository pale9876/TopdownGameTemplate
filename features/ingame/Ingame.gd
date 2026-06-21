# ingame.gd
extends CanvasLayer


func _init() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	follow_viewport_enabled = true


func change_scene(link: String) -> void:
	var scene: Map = (load(link) as PackedScene).instantiate()
	get_main_scene().ingame.remove_child(Global.player)
	get_main_scene().queue_free()
	
	Global.main_scene.current_map = scene
	
	add_child(scene)


func get_main_scene(): return Global.main_scene
