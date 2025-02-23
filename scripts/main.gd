extends Node2D

@export var car: Node2D
@export var replacements: ColorRect
@export var removed_parts: Node2D
@export var explosion: AnimatedSprite2D
@export var death_screen: Control
@export var gas_can: Sprite2D

var dragging = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Next Car"):
		car.nextCar = true
		for replacement in replacements.get_children():
			if (replacement.global_position.distance_to(car.get_node("Car Pieces").get_node(replacement.markerName).global_position) < 10):
				car.get_node("Car Pieces").get_node(replacement.markerName).visible = true
				replacement.visible = false
		for part in removed_parts.get_children():
			if (part.global_position.distance_to(car.get_node("Car Pieces").get_node(part.markerName).global_position) < 10):
				car.get_node("Car Pieces").get_node(part.markerName).visible = true
				part.visible = false


func _on_car_check_and_reset() -> void:
	var all_visible = true
	for piece in car.get_node("Car Pieces").get_children():
		if not piece.visible:
			all_visible = false
			break
			
	var all_replacements_used = true
	for replacement in replacements.get_children():
		if replacement.visible:
			all_replacements_used = false
			break
	
	if not all_visible or not all_replacements_used or car.gas < 80:
		explosion.visible = true
		explosion.sprite_frames.set_animation_loop("default", false)
		explosion.play()
		explosion.animation_finished.connect(_explosion_animation_finished)
	
	$death_timer.timeout.connect(_reset_for_next_car)
	$death_timer.set_wait_time(1.0)
	$death_timer.set_one_shot(true)
	$death_timer.start()
	
	for part in removed_parts.get_children():
		part.canDrag = true
	
	car.nextCar = false


func _reset_for_next_car() -> void:
	car.gas = 0
	car.position.x = -825
	car.velocity = 0
	gas_can.position = gas_can.start_pos
	for replacement in replacements.get_children():
		replacement.position = replacement.start_pos
		replacement.visible = true


func _explosion_animation_finished() -> void:
	death_screen.visible = true


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()
