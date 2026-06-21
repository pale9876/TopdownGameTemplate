extends ProgressBar

const Unit = preload("uid://bl84ixx4kubfe")


@onready var visible_timer: Timer = $VisibleTimer


func _enter_tree() -> void:
	var unit := get_parent() as Unit
	unit.stat.damaged.connect(_damaged)


func _ready() -> void:
	visible_timer.timeout.connect(
		func() -> void:
			hide()
	)


func _damaged() -> void:
	visible_timer.start(3.)
	var unit := get_parent() as Unit
	var stat := unit.stat
	var progress: float = float(stat.hp) / float(stat.max_hp)
	
	value = progress
	
	show()
