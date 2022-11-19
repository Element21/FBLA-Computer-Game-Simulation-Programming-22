extends Area

var buoyancy_acceleration = 9.81 * 2
var drag = 2


func _process(delta):
	for letter in LetterManager.letters_in_play:
		
		if overlaps_body(letter):
			
			# Buoyancy
			letter.apply_central_impulse(Vector3(0, 19.62, 0) * letter.mass * delta)

			# Drag
			letter.apply_central_impulse(-letter.linear_velocity * drag * delta)
