extends CharacterBody3D

var speed = SPRINT_SPEED
const WALK_SPEED = 5.0
const SPRINT_SPEED = 11.5
const JUMP_VELOCITY = 4.5
const SENS = 0.0015

var BASE_FOV = 75.0
const SPRINT_FOV = 1.25

#Amplituda glowa
const BOB_FREQ = 1.0
const BOB_AMP = 0.08
var t_bob = 0.8

var gravity = 9.3


var paused = false

@onready var pausemenu = $"../pausemenu"
@onready var head = $Head
@onready var camera = $Head/Camera3D

#Czytanie myszki
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x*SENS)
		camera.rotate_x(-event.relative.y * SENS)
		camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-80),deg_to_rad(75))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

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
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 1.5)
	var target_fov = BASE_FOV + SPRINT_FOV * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)


	move_and_slide()

#funkcja do Ruch glowa/Nie zmieniac nic
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time *BOB_FREQ) * BOB_AMP
	pos.x = cos(time *BOB_FREQ / 2) * BOB_AMP
	return pos
