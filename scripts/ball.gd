extends RigidBody3D

const KICK_FORCE = 8.0
const FRICTION = 0.985

func _ready():
	gravity_scale = 0.0
	linear_damp = 1.0
	angular_damp = 2.0
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = 0.6
	physics_material_override.friction = 0.4
	collision_layer = 2
	collision_mask = 1

func _physics_process(_delta: float):
	# Keep ball on ground
	position.y = 0.2
	# Friction
	if linear_velocity.length() > 0.1:
		linear_velocity *= FRICTION
	else:
		linear_velocity = Vector3.ZERO

func kick(direction: Vector3):
	apply_central_impulse(direction.normalized() * KICK_FORCE)
