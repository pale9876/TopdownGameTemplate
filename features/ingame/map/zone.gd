@tool
extends StaticBody2D


# Import
const Player: Script = preload("uid://c2uxhumgng18h")
const Unit: Script = preload("uid://bl84ixx4kubfe")


# PlaceHolder
const SAMPLE_UNIT: PackedScene = preload("uid://c5ewbb0454kjk")


enum {
	WAIT,
	ENTERED,
	FINISHED,
}

@export var wave: Array[Dictionary]
@export var entry_margin: float = 10.

@export var zone_entry: Area2D

@export_tool_button("Refresh", "2D") var _refresh: Callable = set_margin


var wave_size: int:
	get:
		return wave.size()


@export var spawn_points: Array[Marker2D]


var state: int = WAIT
var _wave_count: int = 0
var _pool: Array[Unit] = []
var _center_point: Vector2:
	get():
		var border_polygon := (get_node("CollisionPolygon2D") as CollisionPolygon2D).polygon
	
		var x: float = border_polygon[0].distance_to(border_polygon[1]) / 2.
		var y: float = border_polygon[0].distance_to(border_polygon[3]) / 2.
	
		return Vector2(x, y)


func _ready() -> void:
	if Engine.is_editor_hint():
		set_margin()
		return
	
	zone_entry.body_entered.connect(_player_entered)
	zone_entry.monitorable = false
	open()


func _player_entered(body: Node2D) -> void:
	if state != WAIT: return
	
	if body is Player:
		print("Player Entered in Zone")
		state = ENTERED
		close()
		request_pool_load()


func request_pool_load() -> void:
	print("spawn units")
	var data := wave[_wave_count] as Dictionary
	
	for index: int in data:
		var unit = data[index].instantiate() as Unit
		var point: Marker2D = spawn_points[index % spawn_points.size()]
		unit.global_position = point.global_position
		
		unit.stat.dead.connect(
			func() -> void:
				_pool.erase(unit)
				
				if _pool.is_empty():
					if _wave_count - 1 == wave.size() - 1:
						state = FINISHED
						open()
					else:
						request_pool_load()
				, CONNECT_ONE_SHOT
		)
		_pool.push_back(unit)
		get_parent().add_child.call_deferred(unit)
	
	_wave_count += 1


func open() -> void:
	await get_tree().physics_frame
	print("Zone Opened")
	(get_node("CollisionPolygon2D") as CollisionPolygon2D).disabled = true


func close() -> void:
	await get_tree().physics_frame
	print("Zone Closed")
	(get_node("CollisionPolygon2D") as CollisionPolygon2D).disabled = false


func set_margin() -> void:
	if !zone_entry: return
	
	var border_polygon := (get_node("CollisionPolygon2D") as CollisionPolygon2D).polygon
	
	var result := PackedVector2Array()
	for point: Vector2 in border_polygon:
		result.push_back(point + point.direction_to(_center_point) * entry_margin)
	
	(zone_entry.get_node("CollisionPolygon2D") as CollisionPolygon2D).polygon = result
