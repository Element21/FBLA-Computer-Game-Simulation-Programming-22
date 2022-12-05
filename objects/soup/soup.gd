extends Area

export(NodePath) onready var level = get_node(level) as Level

var buoyancy_acceleration = 9.81 * 1.1
var drag = 2
var surface = 8.73


func maybe_apply_buoyancy_to_thing(thing: RigidBody, delta: float):
	if thing.global_translation.y < surface && overlaps_body(thing):
		
		# Buoyancy
		thing.apply_central_impulse(Vector3(0, 19.62, 0) * thing.mass * delta)

		# Drag
		thing.apply_central_impulse(-thing.linear_velocity * drag * delta)


func _process(delta):
	for letter in level.letters_in_play:
		maybe_apply_buoyancy_to_thing(letter, delta)
	
	for bubble in level.bubbles_in_play:
		maybe_apply_buoyancy_to_thing(bubble, delta)
