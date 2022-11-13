extends Area

var buoyancy_acceleration = 9.81 * 2
var drag = 2


func _ready() -> void:
	print("Soup spawned")
	connect("body_entered", self, "_on_AreaSoup_body_entered")
	connect("body_exited", self, "_on_AreaSoup_body_exited")


func _process(delta):
	for letter in LetterGetter.letters_in_play:
		
		if overlaps_body(letter):
			
			var pos = letter.translation
			
			# Buoyancy
			letter.apply_central_impulse(Vector3(0, 19.62, 0) * letter.mass * delta)

			# Drag
			letter.apply_central_impulse(-letter.linear_velocity * drag * delta)
