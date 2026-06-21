extends Node


# Import (MetSys)
#const StartMap: Script = preload("uid://di5e7qxe7d0dj")
const MotionCamera = preload("uid://d4jut8uwvfjaj")


# PATH
const SAVE_PATH: String = "user://auto_save.sav"

@export var camera: MotionCamera
@export_file("room_link") var starting_map: String


func init_player() -> void:
	#if FileAccess.file_exists(SAVE_PATH):
		## If save data exists, load it using MetSys SaveManager.
		#var save_manager: SaveManager = SaveManager.new()
		#save_manager.load_from_text(SAVE_PATH)
	#else:
		#MetSys.set_save_data()
	
	#load_room(starting_map)
	#
	#var start_map: StartMap = (map as StartMap)
	#set_player(Global.player)
	#add_module("RoomTransitions.gd")

	#Global.player.global_position = start_map.start_spawn_position.global_position
	
	camera.target = Global.player
