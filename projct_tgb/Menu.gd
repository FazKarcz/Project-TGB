extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	
func _on_lecim_pressed():
	get_tree().change_scene_to_file("res://world.tscn")

func _on_FullScreen_pressed():
	get_tree().change_scene_to_file("res://Options.tscn")

func _on_wysiadam_pressed():
	get_tree().quit()
