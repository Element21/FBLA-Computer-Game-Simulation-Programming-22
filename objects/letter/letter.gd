extends RigidBody

class_name Letter

onready var mesh_instance: MeshInstance = get_child(0)
onready var letter_slap_sound: AudioStreamPlayer3D = get_child(1)

export var which_letter: String
export(NodePath) onready var level = get_node(level)

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
