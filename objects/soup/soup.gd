extends Area

class_name Soup


export(NodePath) onready var level = get_node(level) as Level
export var surface = 8.73

var buoyancy_acceleration = 9.81 * 1.5
var making_upright_acceleration = 5
var drag = 3


func apply_buoyancy_to_thing(thing: RigidBody, delta: float):
	# Buoyancy
	thing.apply_central_impulse(Vector3(0, 19.62, 0) * thing.mass * delta)

	# Drag
	thing.apply_central_impulse(-thing.linear_velocity * drag * delta)
	thing.apply_torque_impulse(-thing.angular_velocity * drag * delta)
	
	# Keeping letters facing upwards
	var direction_facing_vector = thing.get_global_transform().basis.y.normalized()
	var upwards = Vector3(0, 1, 0)
	thing.apply_torque_impulse(direction_facing_vector.cross(upwards) * making_upright_acceleration * delta)


func maybe_apply_buoyancy_to_thing(thing: RigidBody, delta: float):
	if thing.global_translation.y < surface && overlaps_body(thing):
		apply_buoyancy_to_thing(thing, delta)


func _process(delta):
	for letter in level.letters_in_play:
		maybe_apply_buoyancy_to_thing(letter, delta)
	
	for bubble in level.bubbles_in_play:
		if overlaps_body(bubble):
			if bubble.global_translation.y < surface:
				apply_buoyancy_to_thing(bubble, delta)
			else:
				bubble.maybe_pop(delta)


func object_entered(node: Node):
	if node is Letter:
		node.contacted_soup()
