# player_sprite.gd
extends AnimatedSprite2D


@onready var blink_effect_player: AnimationPlayer = $SpriteBlinkPlayer


func _ready() -> void:
	blink_effect_player.animation_finished.connect(
		func(anim_name: StringName) -> void:
			blink_effect_player.play("RESET")
	)
