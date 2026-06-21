extends CanvasLayer


enum Z {
	FRONT,
	UP,
}

@export var z_direction: Z = Z.FRONT
@export var target: Node2D

@onready var listener: AudioListener3D = %AudioListener3D


func set_target(node: Node2D) -> void:
	listener.global_position = pos_to_vec3(node.global_position)


func _enter_tree() -> void:
	Global.channel = self


func _process(_delta: float) -> void:
	if target:
		listener.global_position = pos_to_vec3(target.global_position)


func play(pos: Vector2, stream: AudioStream) -> void:
	var player := AudioStreamPlayer3D.new()
	player.stream = stream
	add_child(player)
	player.global_position = pos_to_vec3(pos)
	player.finished.connect(
		func() -> void:
			player.queue_free()
	)
	player.play()


func pos_to_vec3(pos: Vector2, z_value: float = 0.) -> Vector3:
	return Vector3(
		pos.x, - pos.y, z_value
	) / 50. if z_direction == Z.FRONT else Vector3(pos.x, z_value, - pos.y) / 50.
