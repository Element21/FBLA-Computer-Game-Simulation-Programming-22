extends RigidBody

class_name Letter

onready var mesh_instance: MeshInstance = get_child(0)

export var which_letter: String
export(NodePath) onready var letter_manager = get_node(letter_manager)

# Refactor when we get 3d models from Daniel
func get_mesh() -> Mesh:
	
	var mesh = TextMesh.new()
	
	mesh.text = which_letter
	mesh.font = load("res://resources/letter_font.tres")
	mesh.depth = 0.07
	mesh.uppercase = true
	
	return mesh


func _ready():
	
	var mesh = get_mesh()
	
	mesh_instance.mesh = mesh
	
	letter_manager.put_in_play(self)


