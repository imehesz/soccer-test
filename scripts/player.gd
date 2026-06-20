extends CharacterBody3D

const SPEED = 6.0
const KICK_RANGE = 1.0
const KICK_FORCE = 8.0

@onready var ball: RigidBody3D = get_node("/root/Main/Ball")

func _physics_process(delta: float):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	velocity = direction * SPEED
	velocity.y = -1.0  # Keep grounded
	move_and_slide()

	# Ball Y stays on ground
	position.y = 0.5

	# Kick
	if Input.is_action_just_pressed("kick"):
		_try_kick()

func _try_kick():
	if ball == null or not is_instance_valid(ball):
		return
	var dist = Vector2(position.x, position.z).distance_to(
		Vector2(ball.position.x, ball.position.z))
	if dist <= KICK_RANGE:
		var dir = Vector3(
			ball.position.x - position.x,
			0.0,
			ball.position.z - position.z
		).normalized()
		ball.kick(dir)
