extends Resource
class_name PlayerInformation


@export var level: int = 0
@export var name: StringName = &""
@export var speed: float = 300.
@export var hp: int = 100
@export var sprite: SpriteFrames
@export var portrait: Texture2D
@export var action: Dictionary[String, Dictionary] = {
	"normal_attack" : {
		"cooldown" : .5
	}
}
