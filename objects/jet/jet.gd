extends Spatial


export var power = 1.0
export var dropoff = 1.0


func _ready():
	# It's helpful for the editor, but bad in the game
	get_node("Direction indicator").hide()


func _process(delta):
	for letter_untyped in get_tree().get_nodes_in_group("Letters"):
		var letter = letter_untyped as Letter
		
		var dist = letter.global_translation.distance_to(self.global_translation)
		
		letter.apply_central_impulse(self.transform.basis.x * force_profile(dist / dropoff) * power * delta)


# 1 when the distance is 0, 0 when distance is infinity, looks like a bell curve
func force_profile(dist: float) -> float:
	return 1 / (pow(dist, 2) + 1)
