extends RigidBody

class_name LetterPlatform

var action_time = 1
var launch_vector = Vector2(2, 5)

var score = null
onready var score_mesh: MeshInstance = get_child(0)

var action = null
var time = null
var original_letter_position = null

var letter = null


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


func set_score(new_score):
	score = new_score
	
	var mesh = TextMesh.new()
	
	mesh.font = load("res://resources/letter_font.tres")
	
	if score == null:
		mesh.text = "X"
	else:
		mesh.text = String(new_score)
	
	score_mesh.mesh = mesh
	
	action = "setting score"
	time = 0


func _physics_process(delta):
	
	if time != null:
		
		if action == "flip":
			do_flip_transformation()
		elif action == "launch":
			do_launch_transformation()
		elif action == "setting score":
			do_move_score()
		
		time += delta
		
		if time > action_time:
			time = null


func do_flip_transformation():
	var t = time / action_time
	
	self.rotation_degrees.x = lerp(0, 360, Tweening.smoothify(t))
	
	score_mesh.translation.z = lerp(1.5, 0.334, Tweening.smoothify(t))


func do_launch_transformation():
	var t = time / action_time
	
	var lerp_amt = Tweening.smooth_up_and_down(t)
	
	self.translation.y = lerp(0, launch_vector.y, lerp_amt)
	self.translation.z = lerp(0, launch_vector.x, lerp_amt)
	
	if letter != null && t < launch_curve_inflection_point:
		var lerp_amt_derivative = Tweening.smooth_up_and_down_derivative(t) / action_time
		
		letter.linear_velocity.y = launch_vector.y * lerp_amt_derivative
		letter.linear_velocity.z = launch_vector.x * lerp_amt_derivative
		
		letter.translation.y = original_letter_position.y + lerp(0, launch_vector.y, lerp_amt)
		letter.translation.z = original_letter_position.z + lerp(0, launch_vector.x, lerp_amt)
	
	if t > 0.5:
		score_mesh.translation.z = lerp(1.5, 0.334, Tweening.smoothify((t - 0.5) * 2))


func do_move_score():
	
	score_mesh.translation.z = lerp(0.334, 1.5, Tweening.smoothify(time / action_time))


# When the platform starts slowing down rather than speeding up
# Calculated by finding the first point after t = 0 where the second derivative of smooth_up_and_down is zero (I made my graphing calculator do it for me)
# The letters are unglued from the platform when this time is reached
var launch_curve_inflection_point = 0.234
