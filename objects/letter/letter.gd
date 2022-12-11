extends RigidBody

class_name Letter

onready var mesh_instance: MeshInstance = get_node("Mesh")
onready var letter_slap_sound: AudioStreamPlayer3D = get_node("Slap")
onready var particles: Particles = get_node("Particles")

export var which_letter: String = 'a'


func set_mesh():
	var mesh: ArrayMesh = load("res://resources/letters/" + which_letter + ".obj") as ArrayMesh
	
	mesh_instance.mesh = mesh
	
	undo_mesh_translation(mesh)


# Daniel's letter models are offset, this undoes the translation
# This assumes that the vertices are about evenly spread out, otherwise the average will be biased towards where there's a higher density of vertices
func undo_mesh_translation(mesh: ArrayMesh):
	var avg_translation = Vector3(0, 0, 0)
	
	var mesh_data_tool = MeshDataTool.new()
	mesh_data_tool.create_from_surface(mesh, 0)
	
	var vertex_count = mesh_data_tool.get_vertex_count()
	var inverse_vertex_count = 1.0 / vertex_count
	
	for i in range(vertex_count):
		var vertex = mesh_data_tool.get_vertex(i)
		
		avg_translation += vertex * inverse_vertex_count
	
	
	mesh_instance.translation -= avg_translation


func _ready():
	set_mesh()


func on_collision(node: Node):
	if !node is RigidBody:
		return
	
	# I can't use `is` because that makes a cyclic reference >:-(
	if node.get_script() == self.get_script():
		# Letter on letter sound
		pass
	elif node is LetterPlatform:
		letter_slap_sound.play()
		soup_particle_burst()


func contacted_soup():
	soup_particle_burst()


func soup_particle_burst():
	particles.rotation = -self.rotation
	particles.emitting = true
