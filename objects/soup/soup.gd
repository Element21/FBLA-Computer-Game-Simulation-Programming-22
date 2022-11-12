extends LetterForcefield

export(NodePath) onready var mesh_instance = get_triangles(get_node(mesh_instance).mesh.get_faces())

var buoyancy_acceleration = 9.81 * 2
var drag = 2


# Get all of the triangles in the mesh, change the data structure to be easier to work with, and flatten them into 2d triangles
func get_triangles(mesh_points: PoolVector3Array) -> Array:
	var triangles = []
	
	for i in range(0, (mesh_points.size() / 3)):
		
		var p1 = mesh_points[i * 3 + 0]
		var p2 = mesh_points[i * 3 + 1]
		var p3 = mesh_points[i * 3 + 2]
		
		triangles.push_back([Vector2(p1.x, p1.z), Vector2(p2.x, p2.y), Vector2(p3.x, p3.y)])
	
	return triangles


func buoyancy(letter_height: float):
	var depth = self.translation.y - letter_height
	
	if depth < -0.1:
		return 0
	elif depth < 0.1:
		return buoyancy_acceleration * inverse_lerp(-0.1, 0.1, depth)
	else:
		return buoyancy_acceleration


func force_letter(letter: Letter) -> Vector3:
	var force = Vector3(0, 0, 0)
	
	var pos = letter.translation
		
	# Check if the letter is below the soup, then check if it's in the soup
	if pos.y < self.translation.y + 0.1:
		
		# Check if the letter is above or below one of the triangles in the mesh
		for triangle in mesh_instance:
			
			if Geometry.is_point_in_polygon(Vector2(pos.x, pos.z), triangle):
				var acceleration = buoyancy(pos.y)
				
				# Buoyancy
				force += Vector3(0, acceleration, 0) * letter.mass
				
				# Drag
				force += letter.linear_velocity * drag * -1
				
				break
	
	return force
