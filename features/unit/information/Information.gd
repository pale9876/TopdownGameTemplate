# unit/Information.gd
extends Resource
class_name UnitInformation


@export var name: StringName = &"Minion"
@export var speed: float = 25. # px / sec
@export var hp: int = 50
@export var damange: int = 10 # Collide Damage
@export var sprite: Texture2D
