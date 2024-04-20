extends Control

func _on_play_pressed():
	# TODO: ir al juego en sí
	pass # Replace with function body.


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/settings_menu.tscn")


func _on_credits_pressed():
	# TODO: pantalla de créditos
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
