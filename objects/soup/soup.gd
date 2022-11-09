extends Node

export(NodePath) onready var meshInstance = get_node(meshInstance) as MeshInstance

export var points: PoolVector2Array = [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)]
export var height: float = 0

var buoyancy_acceleration = 9.81 * 2
var drag = 2

# Converts the list of points to a mesh & puts that mesh on the mesh renderer
func set_polygon_points(points):
	
	# Set up the material
	
	var mat = SpatialMaterial.new()
	var color = Color(1, 0, 0)
	
	mat.albedo_color = color
	
	# Find the smallest rectangle that contains all the points
	# This will be used the set the UV coordinates of the points
	
	var minX = INF
	var minY = INF
	var maxX = -INF
	var maxY = -INF
	
	for vertex in points:
		minX = min(minX, vertex.x)
		minY = min(minY, vertex.y)
		maxX = max(maxX, vertex.x)
		maxY = max(maxY, vertex.y)
	
	var diffX = maxX - minX
	var diffY = maxY - minY
	
	# SurfaceTool is used for generating meshes
	
	var surfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
	surfaceTool.set_material(mat)
	
	# Add all the points
	
	for vertex in points:
		surfaceTool.add_color(color)
		surfaceTool.add_uv(Vector2((vertex.x - minX) / diffX, (vertex.y - minY) / diffY))
		surfaceTool.add_vertex(Vector3(vertex.x, 0, vertex.y))
	
	# Get the mesh from the SurfaceTool and assign it to the mesh renderer
	
	var mesh = ArrayMesh.new()
	surfaceTool.commit(mesh);
	
	meshInstance.mesh = mesh
	
	pass

var letters = []

# Recursively search the node tree for all the letters and push them to the list
func push_letters(node: Node):
	
	if node is Letter:
		letters.push_back(node)
		return
	
	for child in node.get_children():
		push_letters(child)


func _ready():
	
	set_polygon_points(points);
	
	push_letters(get_tree().get_root())


func buoyancy(letter_height: float):
	var depth = height - letter_height
	
	if depth < -0.1:
		return 0
	elif depth < 0.1:
		return buoyancy_acceleration * inverse_lerp(-0.1, 0.1, depth)
	else:
		return buoyancy_acceleration

func _process(delta):
	
	for letter in letters:
		var pos = letter.translation
		
		# Check if the letter is below the soup, then check if it's in the soup
		if pos.y < height + 0.1 && Geometry.is_point_in_polygon(Vector2(pos.x, pos.z), points):
			var acceleration = buoyancy(pos.y)
			
			# Buoyancy
			letter.apply_central_impulse(Vector3(0, acceleration, 0) * delta * letter.mass)
			
			# Drag
			letter.apply_central_impulse(letter.linear_velocity * drag * delta * -1)
	
	pass
