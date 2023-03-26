extends RigidBody3D

class_name Letter


@export var word_length: int

var material = preload("res://resources/materials/letter/letter.tres")

@onready var mesh: MeshInstance3D = %Mesh
@onready var particles: GPUParticles3D = %Particles
@onready var which_letter: String = WordUtils.random_letter(word_length)

func set_mesh():
	var new_mesh: ArrayMesh = load("res://resources/letters/" + which_letter + ".obj") as ArrayMesh
	mesh.mesh = new_mesh
	mesh.set_surface_override_material(0, material)
	undo_mesh_translation(new_mesh)


# Daniel's letter models are offset, this undoes the position
# This assumes that the vertices are about evenly spread out, otherwise the average will be biased towards where there's a higher density of vertices
func undo_mesh_translation(new_mesh: ArrayMesh):
	var avg_translation = Vector3(0, 0, 0)
	
	var mesh_data_tool = MeshDataTool.new()
	assert(OK == mesh_data_tool.create_from_surface(new_mesh, 0))
	
	var vertex_count = mesh_data_tool.get_vertex_count()
	var inverse_vertex_count = 1.0 / vertex_count
	
	for i in range(vertex_count):
		var vertex = mesh_data_tool.get_vertex(i)
		
		avg_translation += vertex * inverse_vertex_count
	
	
	mesh.position -= avg_translation


func _ready():
	set_mesh()


func on_collision(node: Node):
	if !node is RigidBody3D:
		return
	
	# I can't use `is` because that makes a cyclic reference >:-(
	if node.get_script() == self.get_script():
		# Letter on letter sound
		pass
	elif node is LetterPlatform:
		(%Slap as AudioStreamPlayer3D).play()
		soup_particle_burst()


func contacted_soup():
	soup_particle_burst()


func soup_particle_burst():
	particles.rotation = -self.rotation
	particles.emitting = true
