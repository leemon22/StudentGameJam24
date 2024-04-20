extends Control

const MUSIC_CHANNEL = 1
const SFX_CHANNEL = 2

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_CHANNEL, lerp(AudioServer.get_bus_volume_db(MUSIC_CHANNEL), value, 0.5))
	if value == -30:
		AudioServer.set_bus_mute(MUSIC_CHANNEL, true)
	else:
		AudioServer.set_bus_mute(MUSIC_CHANNEL, false)


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_CHANNEL, lerp(AudioServer.get_bus_volume_db(SFX_CHANNEL), value, 0.5))
	if value == -30:
		AudioServer.set_bus_mute(SFX_CHANNEL, true)
	else:
		AudioServer.set_bus_mute(SFX_CHANNEL, false)


func _on_continue_pressed():
	# TODO: continuar con la ejecución
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
