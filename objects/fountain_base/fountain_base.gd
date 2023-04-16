extends Area3D


@export var fountain_output: FountainOutput

@export var peak_sucking_force = 20.0
@export var peak_sucking_force_distance = 1.0

# Sinking functionality is to make letters to go under a fountain's collision box
@export var peak_sinking_force = 20.0
@export var peak_sinking_force_distance = 1.0


func _process(delta):
	for letter_untyped in get_tree().get_nodes_in_group("Letters"):
		var letter = letter_untyped as Letter
		
		var displacement: Vector3 = letter.global_position - self.global_position
		var dist = displacement.length()
		
		# Sucking
		letter.apply_central_impulse(-displacement / dist * peak_sucking_force * force_profile(dist / peak_sucking_force_distance) * delta)
		
		# Sinking
		letter.apply_central_impulse(Vector3(0, -peak_sinking_force, 0) * pow(force_profile(dist / peak_sinking_force_distance), 2) * delta)


# Higher as it gets closer, but goes to zero as it gets really close (to avoid instabilities)
func force_profile(dist: float) -> float:
	return 2 * dist / (pow(dist, 2) + 1)


# Launch the letter when it enters the fountain base
func object_entered(object):
	if object is RigidBody3D:
		fountain_output.launch_object(object)
