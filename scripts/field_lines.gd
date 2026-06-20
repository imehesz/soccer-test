extends Node3D

# Draws field markings as thin 3D meshes at runtime

func _ready():
	_add_line(Vector3(0, 0.06, -5), Vector3(0, 0.06, 5), Color.WHITE, 0.08)  # Center line
	_add_dot(Vector3(0, 0.06, 0), 0.2, Color.WHITE)  # Center dot
	_add_ring(Vector3(0, 0.06, 0), 2.5, Color.WHITE, 0.08)  # Center circle

func _add_line(from: Vector3, to: Vector3, color: Color, thickness: float):
	var mesh_inst = MeshInstance3D.new()
	var box = BoxMesh.new()
	var dir = to - from
	box.size = Vector3(thickness, 0.02, dir.length())
	mesh_inst.mesh = box
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.8
	mesh_inst.material_override = mat
	mesh_inst.position = (from + to) / 2.0
	if dir.length() > 0.001:
		mesh_inst.look_at(from + dir, Vector3.UP)
	add_child(mesh_inst)

func _add_dot(pos: Vector3, radius: float, color: Color):
	var mesh_inst = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = radius
	sphere.height = radius * 2
	mesh_inst.mesh = sphere
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.8
	mesh_inst.material_override = mat
	mesh_inst.position = pos
	add_child(mesh_inst)

func _add_ring(center: Vector3, radius: float, color: Color, thickness: float):
	var segments = 32
	var angle_step = TAU / segments
	for i in range(segments):
		var a1 = i * angle_step
		var a2 = (i + 1) * angle_step
		var p1 = center + Vector3(cos(a1) * radius, 0, sin(a1) * radius)
		var p2 = center + Vector3(cos(a2) * radius, 0, sin(a2) * radius)
		_add_line(p1, p2, color, thickness)
