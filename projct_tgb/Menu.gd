extends Control



func _on_lecim_pressed():
	get_tree().change_scene_to_file("res://world.tscn")



func _on_wysiadam_pressed():
	get_tree().quit()
