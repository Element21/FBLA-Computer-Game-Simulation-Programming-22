extends RigidBody

class_name Letter

onready var mesh_instance: MeshInstance = get_child(0)

export var which_letter: String

# Refactor when we get 3d models from Daniel
func get_mesh() -> Mesh:
	
	var mesh = TextMesh.new()
	
	var font_data = DynamicFontData.new()
	font_data.font_path = "res://objects/letter/Plant On Lawn.otf"
	
	var font = DynamicFont.new()
	font.size = 100
	font.font_data = font_data
	
	mesh.text = which_letter
	mesh.font = font
	mesh.depth = 0.058
	
	return mesh


func _ready():
	
	var mesh = get_mesh()
	
	mesh_instance.mesh = mesh
	
	mesh_instance.create_trimesh_collision()
	
	var static_body = mesh_instance.get_child(0)
	var collision_object = static_body.get_child(0)
	
	static_body.remove_child(collision_object)
	mesh_instance.remove_child(static_body)
	add_child(collision_object)
	
	LetterManager.put_in_play(self)

