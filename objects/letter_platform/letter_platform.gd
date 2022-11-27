extends RigidBody


var action_time = 1
var launch_direction = Vector2(-2, 5)

var action = null
var time = null
var original_letter_position = null

var letter: Letter = null


func flip():
	action = "flip"
	time = 0

func launch():
	action = "launch"
	time = 0
	
	if letter != null:
		letter.collision_layer = 0
		letter.collision_mask = 0
		original_letter_position = letter.translation


func _physics_process(delta):
	
	if time != null:
		
		if action == "flip":
			do_flip_transformation()
		elif action == "launch":
			do_launch_transformation()
		
		time += delta
		
		if time > action_time:
			time = null


func do_flip_transformation():
	self.rotation_degrees.x = lerp(0, -360, Utils.smoothify(time / action_time))


func do_launch_transformation():
	var t = time / action_time
	
	var lerp_amt = launch_curve(t)
	
	self.translation.y = lerp(0, launch_direction.y, lerp_amt)
	self.translation.z = lerp(0, launch_direction.x, lerp_amt)
	
	if letter != null && t < launch_curve_inflection_point:
		var lerp_amt_derivative = launch_curve_derivative(t, 1 / action_time)
		
		letter.linear_velocity.y = launch_direction.y * lerp_amt_derivative
		letter.linear_velocity.z = launch_direction.x * lerp_amt_derivative
		
		letter.translation.y = original_letter_position.y + lerp(0, launch_direction.y, lerp_amt)
		letter.translation.z = original_letter_position.z + lerp(0, launch_direction.x, lerp_amt)


# When the platform starts slowing down rather than speeding up
# Calculated by finding the first point after t = 0 where the second derivative of launch_curve is zero (I made my graphing calculator do it for me)
# The letters are unglued from the platform when this time is reached
var launch_curve_inflection_point = 0.234

func launch_curve(t):
	return unsmoothed_launch_curve(Utils.smoothify(t))

func launch_curve_derivative(t, dt):
	# Chain rule twice
	return unsmoothed_launch_curve_derivative(Utils.smoothify(t)) * Utils.smoothify_derivative(t) * dt


func unsmoothed_launch_curve(t):
	return 4*t - 4*t*t

func unsmoothed_launch_curve_derivative(t):
	return 4 - 8*t
