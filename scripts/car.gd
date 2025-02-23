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
	if not nextCar and position.x >= 45:
		for piece: Sprite2D in $"Car Pieces".get_children():
			piece.visible = false
	oldNextCar = nextCar
