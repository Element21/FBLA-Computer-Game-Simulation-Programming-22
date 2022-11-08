extends Node

export(NodePath) onready var meshInstance = get_node(meshInstance) as MeshInstance

export var points: PoolVector2Array = [Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)]

func set_polygon_points(points):
	var mat = SpatialMaterial.new()
	var color = Color(1, 0, 0)
	
	mat.albedo_color = color
	
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
	
	var surfaceTool = SurfaceTool.new()
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
	surfaceTool.set_material(mat)
	
	for vertex in points:
		surfaceTool.add_color(color)
		print(Vector2((vertex.x - minX) / diffX, (vertex.y - minY) / diffY))
		surfaceTool.add_uv(Vector2((vertex.x - minX) / diffX, (vertex.y - minY) / diffY))
		surfaceTool.add_vertex(Vector3(vertex.x, 0, vertex.y))
	
	var mesh = ArrayMesh.new()
	surfaceTool.commit(mesh);
	
	meshInstance.mesh = mesh
	
	pass

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_polygon_points(points);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
