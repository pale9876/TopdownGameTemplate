extends Enemy


@export var long_range_attack_timer: Timer
@export var long_range_attack_state: LimboState


func _ready() -> void:
	super()
	
	long_range_attack_timer.timeout.connect(_long_range_attack_timer_timeout)

func _long_range_attack_timer_timeout() -> void:
	hsm.change_active_state(long_range_attack_state)
	pass


func _long_range_attack() -> void:
	pass
