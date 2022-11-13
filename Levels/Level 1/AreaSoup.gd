extends Area

var buoyancy_acceleration = 9.81 * 2
var drag = 1.2

func buoyancy(letter_height: float):
	var depth = self.translation.y - letter_height

	if depth < -0.1:
		return 0
	elif depth < 0.1:
		return buoyancy_acceleration * inverse_lerp(-0.1, 0.1, depth)
	else:
		return buoyancy_acceleration

func _on_AreaSoup_body_entered(_body:RigidBody) -> void:
	print("entered ", _body)
	set_process(true)

func _on_AreaSoup_body_exited(_body:RigidBody) -> void:
	print("exited ", _body)
	set_process(false)

func _ready() -> void:
	print("Soup spawned")
	connect("body_entered", self, "_on_AreaSoup_body_entered")
	connect("body_exited", self, "_on_AreaSoup_body_exited")

func _process(delta):
	for letter in LetterGetter.letters_in_play:
		var pos = letter.translation
		var acceleration = buoyancy(pos.y)
		# Buoyancy
		letter.apply_central_impulse(Vector3(0, acceleration, 0) * letter.mass * delta)

		# Drag
		letter.apply_central_impulse(-letter.linear_velocity * drag * delta)
