# StartMap.gd
extends Map


@onready var start_spawn_position: Marker2D = %StartSpawnPosition


func _ready() -> void:
	if !Engine.is_editor_hint():
		#Global.player
		pass
