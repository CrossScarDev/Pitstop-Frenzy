extends Node2D

var velocity = 0

@export var APPROACH_FRICTION: float

var nextCar = false;
var oldNextCar = false

var gas = 0

signal check_and_reset

func _process(delta: float) -> void:
	if position.x < 45:
		velocity += delta * 100
		velocity *= APPROACH_FRICTION
		position.x += velocity
	if oldNextCar != nextCar:
		velocity = 0
	if nextCar:
		if position.x < get_viewport_rect().size.x - 325:
			velocity += delta * 100
			position.x += velocity
		else:
			check_and_reset.emit()
	oldNextCar = nextCar

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		for piece: Sprite2D in $"Car Pieces".get_children():
			if piece.get_rect().has_point(piece.to_local(event.position)):
				piece.visible = false
