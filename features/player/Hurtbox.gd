# player/hurtbox.gd
extends Area2D


const Player: Script = preload("uid://c2uxhumgng18h")


@export var is_guarding: bool = false


@onready var invincible_timer: Timer = $InvincibleTimer


func _init() -> void:
	monitorable = true
	monitoring = false
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, true)


func _ready() -> void:
	invincible_timer.timeout.connect(
		func() -> void:
			var player := get_parent() as Player
			if !player.state.is_neutralized():
				monitorable = true
				player.sprite.blink_effect_player.play(&"RESET")
	)


func damaged(hit_result: HitResult) -> void:
	var player: Player = get_parent() as Player
	
	var attack_dir: Vector2 = player.global_position.direction_to(
		hit_result.from.global_position
	)
	
	player.stat.hp -= hit_result.damage
	player.stat.damaged.emit()
	
	var knockback_force: Vector2 = - attack_dir * hit_result.force
	
	if player.stat.hp > 0:
		player.knockbacked(knockback_force, hit_result.af_time)

		if hit_result.af_time > 0.:
			invincible_timer.start(1.)
			player.sprite.blink_effect_player.play(&"invincible")
			await get_tree().physics_frame
			monitorable = false
	
	
	
	
