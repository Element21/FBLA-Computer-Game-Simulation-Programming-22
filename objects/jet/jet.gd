extends Node3D


@export var power = 1.0
@export var dropoff = 1.0
@export var stream_pulling_force = 3.0
@export var stream_pulling_distance = 3.5


func _ready():
	# It's helpful for the editor, but bad in the game
	get_node("Direction indicator").hide()
	print(self.global_transform.basis.z)


func _process(delta):
	for letter_untyped in get_tree().get_nodes_in_group("Letters"):
		var letter = letter_untyped as Letter
		
		var dist = letter.global_translation.distance_to(self.global_translation)
		
		var force_scale = force_profile(dist / dropoff)
		
		letter.apply_central_impulse(self.transform.basis.x * force_scale * power * delta)
		
		# Pull letters towards the jet, prevents the letters from going out the the stream due to centripetal force
		var letter_local_pos = self.to_local(letter.global_translation)
		
		letter.apply_central_impulse(-self.global_transform.basis.z * delta * stream_pulling_force * force_scale * stream_force_profile(letter_local_pos.z / stream_pulling_distance))


# 1 when the distance is 0, 0 when distance is infinity, looks like a bell curve
func force_profile(dist: float) -> float:
	return 1 / (pow(dist, 2) + 1)


# -1 at z=-1, 0 at z=0, 1 at z=1, drops off outside that range. Derivative is zero at z= -1, 0, 1
func stream_force_profile(z: float) -> float:
	var v = 2.5 * pow(z, 3) - 1.5 * pow(z, 5)
	
	if z > 0:
		return max(v, 0)
	else:
		return min(v, 0)
