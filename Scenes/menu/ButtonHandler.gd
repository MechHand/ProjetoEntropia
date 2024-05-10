extends Node

const GAME_SCENE = preload("res://Scenes/game_scene.tscn")


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)


func _on_settings_btn_pressed() -> void:
	pass # Replace with function body.


func _on_exit_btn_pressed() -> void:
	get_tree().quit()
