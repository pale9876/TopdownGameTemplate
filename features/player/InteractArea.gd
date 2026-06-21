# player/interact.gd
extends Area2D

# Import
const NPC: Script = preload("uid://btmmen2m5ofg7")
const Player: Script = preload("uid://c2uxhumgng18h")


# Bodies interacting with player
var interacting: Array[Node2D] = []


func _init() -> void:
	#monitoring = true
	#monitorable = false
	
	#set_collision_layer_value(1, false)
	#set_collision_mask_value(1, false)
	#
	#set_collision_mask_value(2, true)
	pass

func _enter_tree() -> void:
	body_entered.connect(_entered)
	body_exited.connect(_exited)
	
	var player: Player = get_parent() as Player
	
	player.state.face_changed.connect(
		func(value: Vector2i) -> void:
			rotation = Vector2(value).angle()
	)


func _exit_tree() -> void:
	body_entered.disconnect(_entered)
	body_exited.disconnect(_exited)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and !event.is_echo():
		if event.is_action_pressed("interact"):
			if !interacting.is_empty():
				#var unit: Player = get_parent() as Player
				await get_tree().physics_frame

				Global.start_dialog(
					(interacting[0] as NPC), "greeting", "GREETING"
				)
				#print("Interact")
				


func _entered(body: Node2D) -> void:
	if body is NPC:
		#print("NPC Interact Area entered => ", body.name)
		interacting.push_back(body)


func _exited(body: Node2D) -> void:
	if interacting.has(body):
		#print("NPC Interact Area exited => ", body.name)
		interacting.erase(body)
