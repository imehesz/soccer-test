extends Node3D
# Generates curved wall segments for hockey-style rounded corners
# Plus straight wall segments between the corners

@export var radius: float = 2.0
@export var segments: int = 20
@export var thickness: float = 0.25
@export var wall_height: float = 0.5

func _ready():
	# Curved corners (8 segments each, 90° arc)
	_make_arc(Vector3(-10, 0.25, -3), 180, 270)   # Top-left
	_make_arc(Vector3(10, 0.25, -3), 270, 360)    # Top-right
	_make_arc(Vector3(-10, 0.25, 3), 90, 180)     # Bottom-left
	_make_arc(Vector3(10, 0.25, 3), 0, 90)        # Bottom-right

	# Straight walls between corners
	_make_straight(Vector3(0, 0.25, -5), Vector2(20, 0.2))    # Top: x=-10 to x=10
	_make_straight(Vector3(0, 0.25, 5), Vector2(20, 0.2))     # Bottom: x=-10 to x=10
	_make_straight(Vector3(12, 0.25, 0), Vector2(0.2, 6))     # Right: z=-3 to z=3
	_make_straight(Vector3(-12, 0.25, -4), Vector2(0.2, 2))   # Left top: z=-5 to z=-3
	_make_straight(Vector3(-12, 0.25, 4), Vector2(0.2, 2))    # Left bottom: z=3 to z=5

func _make_arc(center: Vector3, start_deg: float, end_deg: float):
	var step = (end_deg - start_deg) / segments
	for i in range(segments):
		var a1 = deg_to_rad(start_deg + i * step)
		var a2 = deg_to_rad(start_deg + (i + 1) * step)
		var mid_angle = (a1 + a2) / 2.0
		var seg_len = 2.0 * radius * sin(deg_to_rad(step) / 2.0)

		var pos = center + Vector3(cos(mid_angle) * radius, 0, sin(mid_angle) * radius)
		var tangent_angle = mid_angle + PI / 2.0

		var body = StaticBody3D.new()
		body.position = pos
		body.collision_mask = 2
		var shape = CollisionShape3D.new()
		var box = BoxShape3D.new()
		box.size = Vector3(seg_len + 0.05, wall_height, thickness)
		shape.shape = box
		body.add_child(shape)

		var mesh_inst = MeshInstance3D.new()
		var box_mesh = BoxMesh.new()
		box_mesh.size = Vector3(seg_len + 0.05, wall_height, thickness)
		mesh_inst.mesh = box_mesh
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.9, 0.9, 0.9, 1)
		mat.roughness = 0.4
		mesh_inst.material_override = mat
		body.add_child(mesh_inst)

		body.rotation.y = tangent_angle
		add_child(body)

func _make_straight(pos: Vector3, size: Vector2):
	var body = StaticBody3D.new()
	body.position = pos
	body.collision_mask = 2
	var shape = CollisionShape3D.new()
	var box = BoxShape3D.new()
	box.size = Vector3(size.x, wall_height, size.y)
	shape.shape = box
	body.add_child(shape)

	var mesh_inst = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(size.x, wall_height, size.y)
	mesh_inst.mesh = box_mesh
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.9, 0.9, 0.9, 1)
	mat.roughness = 0.4
	mesh_inst.material_override = mat
	body.add_child(mesh_inst)

	add_child(body)
