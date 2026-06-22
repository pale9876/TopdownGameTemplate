# border.gd
@tool
extends StaticBody2D


const Map: Script = preload("uid://di5e7qxe7d0dj")


enum {
	LEFT = 1,
	TOP = 2,
	RIGHT = 4,
	BOTTOM = 8,
}


@export var is_closed: bool


@onready var left: CollisionShape2D = $Left
@onready var top: CollisionShape2D = $Top
@onready var right: CollisionShape2D = $Right
@onready var bottom: CollisionShape2D = $Bottom


func _init() -> void:
	input_pickable = false


func _enter_tree() -> void:
	pass
	#assert(get_parent() is Map)


#func _draw() -> void:
	#if Engine.is_editor_hint():
		#var parent: Map = get_parent() as Map
		#if parent:
			#draw_rect(
				#Rect2(
					#Vector2(),
					#parent.get_map_size()
				#), Color(0.541, 0.69, 1.0, 0.275)
			#)


func set_border(to: Vector2i, opened: int, open: bool = false) -> void:
	var parent: Map = get_parent() as Map
	
	var from: Vector2 = Vector2(parent.margin / 2., parent.margin / 2.)
	var margin_to: Vector2 = Vector2(to) - Vector2(parent.margin / 2., parent.margin / 2.)
	
	var _tl: Vector2 = Vector2(from)
	var _tr: Vector2 = Vector2(margin_to.x, from.y)
	var _bl: Vector2 = Vector2(from.x, margin_to.y)
	var _br: Vector2 = Vector2(margin_to)
	
	var seg_left: SegmentShape2D = get_left()
	var seg_top: SegmentShape2D = get_top()
	var seg_right: SegmentShape2D = get_right()
	var seg_bottom: SegmentShape2D = get_bottom()
	
	# 왼쪽 세그먼트 진행 방향 (왼쪽 위 > 왼쪽 아래)
	seg_left.a = _tl
	seg_left.b = _bl
	
	# 위쪽 세그먼트 진행 방향 (왼쪽 위 > 오른쪽 위)
	seg_top.a = _tl
	seg_top.b = _tr
	
	# 오른쪽 세그먼트 진행 방향 (오른쪽 위 > 오른쪽 아래)
	seg_right.a = _tr
	seg_right.b = _br
	
	# 아래쪽 세그먼트 진행 방향 (왼쪽 아래 > 오른쪽 아래)
	seg_bottom.a = _bl
	seg_bottom.b = _br

	if open:
		left.disabled = (func() -> bool:
			seg_top.a -= Vector2(parent.margin / 2., 0.)
			seg_bottom.a -= Vector2(parent.margin / 2., 0.)
			return true
		).call() as bool if opened & LEFT else false
		
		
		top.disabled = (func() -> bool:
			seg_left.a -= Vector2(0., parent.margin / 2.)
			seg_right.a -= Vector2(0., parent.margin / 2.)
			return true
		).call() as bool if opened & TOP else false
		
		
		right.disabled = (func() -> bool:
			seg_top.b += Vector2(parent.margin / 2., 0.)
			seg_bottom.b += Vector2(parent.margin / 2., 0.)
			return true
		).call() as bool if opened & RIGHT else false
		
		
		bottom.disabled = (func() -> bool:
			seg_left.b += Vector2(0., parent.margin / 2.)
			seg_right.b += Vector2(0., parent.margin / 2.)
			return true
		).call() as bool if opened & BOTTOM else false

	else:
		for seg: CollisionShape2D in [left, top, right, bottom]:
			seg.disabled = false


func get_map() -> Map: return get_parent() as Map


func get_left() -> SegmentShape2D: return left.shape as SegmentShape2D
func get_top() -> SegmentShape2D: return top.shape as SegmentShape2D
func get_right() -> SegmentShape2D: return right.shape as SegmentShape2D
func get_bottom() -> SegmentShape2D: return bottom.shape as SegmentShape2D
