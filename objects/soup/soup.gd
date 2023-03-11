extends Area3D

class_name Soup


@export var level: Level
@export var surface = 8.73

var buoyancy_acceleration = 9.81 * 1.5
var making_upright_acceleration = 5
var drag = 3


func apply_buoyancy_to_thing(thing: RigidBody3D, delta: float):
	# Buoyancy
	thing.apply_central_impulse(Vector3(0, 19.62, 0) * thing.mass * delta)

	# Drag
	thing.apply_central_impulse(-thing.linear_velocity * drag * delta)
	thing.apply_torque_impulse(-thing.angular_velocity * drag * delta)
	
	# Keeping letters facing upwards
	# apply_torque_impulse applies a torque clockwise to the vector inputted, the cross product is useful for getting at that vector
	# It also reduces in magnitude the more similar the vectors are, which is also exactly what I need
	var direction_facing_vector = thing.get_global_transform().basis.y.normalized()
	var upwards = Vector3(0, 1, 0)
	var torque = direction_facing_vector.cross(upwards) * making_upright_acceleration * delta
	
	if direction_facing_vector.y > 0:
		thing.apply_torque_impulse(torque)
	else:
		# Prevent it from flipping over if it's upside down
		thing.apply_torque_impulse(-torque)


func maybe_apply_buoyancy_to_thing(thing: RigidBody3D, delta: float):
	if thing.global_translation.y < surface && overlaps_body(thing):
		apply_buoyancy_to_thing(thing, delta)


func _process(delta):
	for letter in get_tree().get_nodes_in_group("Letters"):
		maybe_apply_buoyancy_to_thing(letter, delta)
	
	for bubble in get_tree().get_nodes_in_group("Bubbles"):
		if overlaps_body(bubble):
			if bubble.global_translation.y < surface:
				apply_buoyancy_to_thing(bubble, delta)
			else:
				# Maybe pop it if it's above the surface
				bubble.maybe_pop(delta)


# Tell the letters to do the particle thing
func object_entered(node: Node):
	if node is Letter:
		node.contacted_soup()
