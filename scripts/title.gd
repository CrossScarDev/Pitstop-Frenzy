extends Control


func _on_go_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
