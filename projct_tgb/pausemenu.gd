extends Control

func _ready():
	hide()

func resume():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	
func pause():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	
func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		resume()

func _on_jazda_pressed():
	resume()

func _on_wychodze_pressed():
	get_tree().quit()

func _process(delta):
	testEsc()

