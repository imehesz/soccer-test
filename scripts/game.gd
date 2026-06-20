extends Node3D

var score: int = 0
var resetting: bool = false
var player_start: Vector3 = Vector3(0, 0.5, 0)
var ball_start: Vector3 = Vector3(-2.0, 0.2, 0.0)

@onready var player: CharacterBody3D = $Player
@onready var ball: RigidBody3D = $Ball
@onready var score_label: Label = $UI/ScoreLabel

func _ready():
	_update_score_display()

func _process(_delta: float):
	if resetting:
		return
	# Goal scored — ball past goal line in the goal opening
	if ball.position.x < -12.0 and abs(ball.position.z) < 1.3:
		score += 1
		_update_score_display()
		_reset_positions()
	# Ball going wrong way (past center to the right) — reset without scoring
	elif ball.position.x > 2.0:
		_reset_positions()

func _update_score_display():
	score_label.text = "SCORE: %d" % score

func _reset_positions():
	resetting = true
	await get_tree().create_timer(1.0).timeout
	player.position = player_start
	ball.position = ball_start
	ball.linear_velocity = Vector3.ZERO
	ball.angular_velocity = Vector3.ZERO
	ball.rotation = Vector3.ZERO
	resetting = false
