extends Node2D

@export var car: Node2D
@export var replacements: Sprite2D
@export var removed_parts: Node2D
@export var explosion: AnimatedSprite2D
@export var death_screen: Control
@export var gas_can: Sprite2D
@export var timer: TextureProgressBar
@export var score_label: Label

var dragging = false

var increment_timer = true

var score: int = 0

@export var audio_player: AudioStreamPlayer2D
var explosion_sfx = preload("res://audio/explosion.mp3")


func _ready() -> void:
	timer.max_value = Global.timer_length
	timer.value = Global.timer_length


func _process(delta: float) -> void:
	if increment_timer:
		timer.value -= delta
		if timer.value <= 0:
			death("You Ran Out of Time")
	
	if Input.is_action_just_pressed("Next Car") and not explosion.visible and not car.nextCar:
		car.nextCar = true
		increment_timer = false
		for replacement in replacements.get_children():
			if (replacement.global_position.distance_to(car.get_node("Car Pieces").get_node(NodePath(replacement.name)).global_position) < 10):
				car.get_node("Car Pieces").get_node(NodePath(replacement.name)).visible = true
				replacement.visible = false
		for part in removed_parts.get_children():
			if (part.global_position.distance_to(car.get_node("Car Pieces").get_node(NodePath(part.name)).global_position) < 10):
				car.get_node("Car Pieces").get_node(NodePath(part.name)).visible = true
				part.visible = false


func _on_car_check_and_reset() -> void:
	car.nextCar = false
	await get_tree().create_timer(2).timeout
	audio_player.stop()
	audio_player.volume_db = 0
	
	var all_parts_trashed = true
	for part in removed_parts.get_children():
		if part.visible:
			all_parts_trashed = false
			break
			
	var all_replacements_used = true
	for replacement in replacements.get_children():
		if replacement.visible:
			all_replacements_used = false
			break
	
	if not all_parts_trashed or not all_replacements_used or car.gas < 80:
		death("You Failed To Replace All The Parts and Refuel")
	else:
		score += round(timer.value)
		score_label.text = "Score: " + str(score)
	
	$reset_timer.timeout.connect(_reset_for_next_car)
	$reset_timer.set_wait_time(1.0)
	$reset_timer.set_one_shot(true)
	$reset_timer.start()


func death(message: String) -> void:
	set_process(false)
	death_screen.get_node("Message").text = message + "\nYour Score: " + str(score)
	
	explosion.visible = true
	explosion.sprite_frames.set_animation_loop("default", false)
	explosion.play()
	explosion.animation_finished.connect(_explosion_animation_finished)
	
	if not audio_player.playing:
		audio_player.stream = explosion_sfx
		audio_player.volume_db = -25
		audio_player.play()
		audio_player.finished.connect(_reset_audio_player)


func _reset_audio_player() -> void:
	audio_player.volume_db = 0
	audio_player.finished.disconnect(_reset_audio_player)


func _reset_for_next_car() -> void:
	timer.value = timer.max_value
	increment_timer = true
	car.gas = 0
	car.position.x = -825
	car.velocity = 0
	gas_can.position = gas_can.start_pos
	for replacement in replacements.get_children():
		replacement.position = replacement.start_pos
		replacement.visible = true
	for piece in car.get_node("Car Pieces").get_children():
		piece.visible = true
	for part in removed_parts.get_children():
		part.canDrag = true


func _explosion_animation_finished() -> void:
	death_screen.visible = true


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()
