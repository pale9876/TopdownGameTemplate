extends Node


# Import
const Channel: Script = preload("uid://bc33hejnp7byc")
const Ingame: Script = preload("uid://lf1g8r7wbov3")
const Option: Script = preload("uid://b6wu325meysae")
const Title: Script = preload("uid://dtu3imugbu0pm")
const Hud: Script = preload("uid://dgntyiu05self")
const StartMap: Script = preload("uid://g5dmqwwgaa47")

const DialogUI: Script = preload("uid://borjea45xky04")

const START_MAP_SCENE: PackedScene = preload("uid://ccd41t1qrjttn")


@onready var ingame: Ingame = $Ingame
@onready var hud: Hud = $HUD
@onready var option:Option = $Option
@onready var channel: Channel = $Channel
@onready var title: Title = $Title


var is_in_game: bool = false
var current_map: Map = null

func _ready() -> void:
	ingame.process_mode = Node.PROCESS_MODE_DISABLED
	
	ingame.hide()
	hud.hide()
	option.hide()
	channel.hide()
	
	title.show()

	option.close.button_up.connect(_option_close)
	title.option.button_up.connect(_option_open)

	GSignal.start.connect(on_start)
	Global.main_scene = self
	
	channel.set_target(Global.player)


func on_start() -> void:
	ingame.show()
	hud.show()
	
	title.hide()
	channel.hide()

	ingame.process_mode = Node.PROCESS_MODE_INHERIT

	current_map = START_MAP_SCENE.instantiate() as StartMap
	ingame.add_child(current_map)
	
	Global.player.global_position = current_map.start_spawn_position.global_position
	current_map.add_player()
	
	is_in_game = true


func _option_close() -> void:
	if !is_in_game:
		title.show()
	
	option.hide()


func _option_open() -> void:
	if !is_in_game:
		title.hide()

	option.show()


func get_dialog_ui() -> DialogUI: return hud.dialog_ui
