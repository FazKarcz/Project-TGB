extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 12.5
const JUMP_VELOCITY = 4.5
const SENS = 0.005

var BASE_FOV = 75.0
const SPRINT_FOV = 2.0

#Amplituda glowa
const BOB_FREQ = 3.0
const BOB_AMP = 0.08
var t_bob = 0.8

var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera3D

#Czytanie myszki
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x*SENS)
		camera.rotate_x(-event.relative.y * SENS)
		camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-50),deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	#SPRINT
	if Input.is_action_pressed("dash") and is_on_floor():
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Skok
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	

	#Chodzenie
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	#Ruch glowa
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	

#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + SPRINT_FOV * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	if Input.is_action_pressed("esc"):
		get_tree().change_scene_to_file("res://menu.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	move_and_slide()

#funkcja do Ruch glowa
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time *BOB_FREQ) * BOB_AMP
	pos.x = cos(time *BOB_FREQ / 2) * BOB_AMP
	return pos

