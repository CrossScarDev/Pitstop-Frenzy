extends Sprite2D

var dragging = false
var drag_offset: Vector2

@export var car: Node2D
@export var overlay: ColorRect

var start_pos: Vector2


func _ready() -> void:
	start_pos = position


func _process(delta: float) -> void:
	if $Marker2D.global_position.distance_to(car.get_node("Gas Valve").global_position) < 15 and dragging:
		car.gas += delta * 10
		if car.gas > 100:
			car.gas = 100
	
	overlay.get_node("Progress").size.y = (car.gas / 100) * (overlay.size.y - 10)
	overlay.get_node("Progress").position.y = 5
	overlay.get_node("Progress").color = lerp(Color(1, 0, 0), Color(0.25, 1, 0), car.gas / 100)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				dragging = true
				drag_offset = get_global_mouse_position() - global_position
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset
