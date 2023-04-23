extends RigidBody3D

class_name Letter


@export var word_length: int

var material = preload("res://resources/materials/letter/letter.tres")

@onready var mesh: MeshInstance3D = %Mesh
@onready var particles: GPUParticles3D = %Particles
@onready var which_letter: String = WordUtils.random_letter(word_length)
@onready var hand: Hand

func set_mesh():
	mesh.mesh = WordUtils.mesh_of(which_letter)
	mesh.set_surface_override_material(0, material)
	mesh.position = WordUtils.inverse_translation_of(which_letter)


func _ready():
	set_mesh()
	change_letter()


func change_letter():
	await get_tree().create_timer(randf() * 10. + 10.).timeout
	
	change_letter()
	
	if hand.hand.global_position.distance_to(self.global_position) < 5.:
		return
	
	if !self.is_in_group("Letters"): return
	
	self.apply_central_impulse(Vector3(0, -5, 0))
	
	await get_tree().create_timer(.1).timeout
	
	if !self.is_in_group("Letters"): return
	
	which_letter = WordUtils.random_letter(word_length)
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
