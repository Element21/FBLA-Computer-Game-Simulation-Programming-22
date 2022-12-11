extends Area

export var launching_impulse = 25.0

export var peak_sucking_force = 20.0
export var peak_sucking_force_distance = 1.0

# Sinking functionality is to make letters to go under a fountain's collision box
export var peak_sinking_force = 20.0
export var peak_sinking_force_distance = 1.0


func _process(delta):
	for letter_untyped in get_tree().get_nodes_in_group("Letters"):
		var letter = letter_untyped as Letter
		
		var displacement = letter.global_translation - self.global_translation
		var dist = displacement.length()
		
		# Sucking
		letter.apply_central_impulse(-displacement / dist * peak_sucking_force * force_profile(dist / peak_sucking_force_distance) * delta)
		
		# Sinking
		letter.apply_central_impulse(Vector3(0, -peak_sinking_force, 0) * force_profile(dist / peak_sinking_force_distance) * delta)


func force_profile(dist: float) -> float:
	return dist / (pow(dist, 2) + 1)


func object_entered(object):
	if object is Letter:
		object.apply_central_impulse(Vector3(0, launching_impulse, 0))
