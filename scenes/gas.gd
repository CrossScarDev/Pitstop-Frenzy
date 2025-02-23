extends Sprite2D

var dragging = false
var drag_offset: Vector2

@export var car: Node2D
@export var overlay: Sprite2D
@export var main: Node2D

var start_pos: Vector2

@export var audio_player: AudioStreamPlayer2D
var gas_sfx = preload("res://audio/gas.mp3")


func _ready() -> void:
	start_pos = position


func _process(delta: float) -> void:
	if $Marker2D.global_position.distance_to(car.get_node("Gas Valve").global_position) < 15 and dragging:
		car.gas += delta * 10
		if car.gas < 100:
			if not audio_player.playing:
				audio_player.stream = gas_sfx
				audio_player.play()
		elif audio_player.stream == gas_sfx:
			audio_player.stop()
		if car.gas > 100:
			car.gas = 100
	elif audio_player.stream == gas_sfx:
			audio_player.stop()
	
	var progress: ProgressBar = overlay.get_node("Progress")
	progress.value = car.gas
	var stylebox = StyleBoxFlat.new()
	progress.add_theme_stylebox_override("fill", stylebox)
	stylebox.bg_color = lerp(Color(1, 0, 0), Color(0.25, 0.75, 0), car.gas / 100)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not main.dragging:
			if get_rect().has_point(to_local(event.position)):
				dragging = true
				main.dragging = true
				drag_offset = get_global_mouse_position() - global_position
		else:
			dragging = false
			main.dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset
