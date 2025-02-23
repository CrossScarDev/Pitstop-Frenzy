extends Control


func _on_easy_pressed() -> void:
	Global.timer_length = 25
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_medium_pressed() -> void:
	Global.timer_length = 22
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_hard_pressed() -> void:
	Global.timer_length = 20
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
