extends MeshInstance

var buoyancy_acceleration = 9.81 * 2
var drag = 2

func buoyancy(letter_height: float):
	var depth = self.translation.y - letter_height

	if depth < -0.1:
		return 0
	elif depth < 0.1:
		return buoyancy_acceleration * inverse_lerp(-0.1, 0.1, depth)
	else:
		return buoyancy_acceleration

func _ready() -> void:
	connect("body_entered", self, "_on_Soup_body_entered")
	connect("body_exited", self, "_on_Soup_body_exited")

func _process(delta):
	for letter in LetterGetter.letters_in_play:
		var pos = letter.translation
		var acceleration = buoyancy(pos.y)
		# Buoyancy
		letter.apply_central_impulse(Vector3(0, acceleration, 0) * letter.mass * delta)

		# Drag
		letter.apply_central_impulse(letter.linear_velocity * drag * -1 * delta)

func _on_Soup_body_entered():
	set_process(true)

func _on_Soup_body_exited():
	set_process(true)
