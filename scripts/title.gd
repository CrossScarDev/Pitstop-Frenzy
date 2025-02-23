extends Control


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Next Car"):
		get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_go_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
