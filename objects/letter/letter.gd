extends RigidBody

class_name Letter

onready var mesh_instance: MeshInstance = get_child(0)
onready var letter_slap_sound: AudioStreamPlayer3D = get_child(1)

export var which_letter: String
export(NodePath) onready var level = get_node(level)

# Refactor when we get 3d models from Daniel
func set_mesh():
	var mesh: ArrayMesh = load("res://resources/letters/" + which_letter + ".obj") as ArrayMesh
	
	var avg_translation = Vector3(0, 0, 0)
	
	var mesh_data_tool = MeshDataTool.new()
	mesh_data_tool.create_from_surface(mesh, 0)
	
	var vertex_count = mesh_data_tool.get_vertex_count()
	var inverse_vertex_count = 1.0 / vertex_count
	
	for i in range(vertex_count):
		var vertex = mesh_data_tool.get_vertex(i)
		
		avg_translation += vertex * inverse_vertex_count
	
	mesh_instance.mesh = mesh
	mesh_instance.translation -= avg_translation


func _ready():
	set_mesh()
	
	level.put_letter_in_play(self)


func on_collision(node: Node):
	if !node is RigidBody:
		return
	
	# I can't use `is` because that makes a cyclic reference >:-(
	if node.get_script() == self.get_script():
		# Letter on letter sound
		pass
	else:
		letter_slap_sound.play()
