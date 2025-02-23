extends Sprite2D

var dragging = false
var drag_offset: Vector2
var canDrag = true

@export var car: Node2D
@export var markerName: String
@export var fromCar: bool
@export var removed_parts: Node2D
@export var trash_can: Sprite2D
@export var main: Node2D

var start_pos: Vector2

@export var audio_player: AudioStreamPlayer2D
var click_sfx = preload("res://audio/click.mp3")


func _ready() -> void:
	start_pos = position

func _process(delta: float) -> void:
	if not canDrag:
		return
	
	if fromCar:
		if !car.get_node("Car Pieces").get_node(NodePath(name)).visible and !visible:
			visible = true
			global_position = car.get_node("Car Pieces").get_node(NodePath(name)).global_position

func _input(event: InputEvent) -> void:
	if not canDrag:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and (fromCar or (!removed_parts.get_node(NodePath(name)).visible) and !car.get_node("Car Pieces").get_node(NodePath(name)).visible):
			if event.pressed and not main.dragging:
				if get_rect().has_point(to_local(event.position)):
					if not audio_player.playing:
						audio_player.stream = click_sfx
						audio_player.play()
					dragging = true
					main.dragging = true
					drag_offset = get_global_mouse_position() - global_position
			else:
				dragging = false
				main.dragging = false
				if fromCar:
					if get_rect().intersects(Rect2(to_local(trash_can.to_global(trash_can.get_rect().position)), trash_can.get_rect().size)):
						visible = false
						canDrag = false
	elif event is InputEventMouseMotion and dragging:
		set_global_position(get_global_mouse_position() - drag_offset);
		if (global_position.distance_to(car.get_node("Car Pieces").get_node(markerName).global_position) < 10):
			if not audio_player.playing:
				audio_player.stream = click_sfx
				audio_player.play()
			set_global_position(car.get_node("Car Pieces").get_node(markerName).global_position)
