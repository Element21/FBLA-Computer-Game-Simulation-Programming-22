extends RigidBody3D

class_name LetterPlatform

var index: int

var action_time = 1
var launch_vector = Vector3(0, 2, 5)

var score = null

@onready var original_x = self.position.x

var action = null
var time = null
var original_letter_position = null

var letter = null

@onready var whoosh = %Whoosh as AudioStreamPlayer3D
@onready var score_mesh = %"Score mesh" as MeshInstance3D

@onready var score_mesh_start_z = score_mesh.position.z


func flip():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.set_parallel()
	@warning_ignore("return_value_discarded")
	tween.tween_property(self, "rotation_degrees", Vector3(360, 0, 0), action_time).set_trans(Tween.TRANS_SINE)
	@warning_ignore("return_value_discarded")
	tween.tween_property(score_mesh, "position", Vector3(0, 0, score_mesh_start_z), action_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	whoosh.play()
	
	await tween.finished
	
	self.rotation_degrees = Vector3(0, 0, 0)


func launch():
	action = "launch"
	time = 0
	
	if letter != null:
		# Disable collision for the letter, prevents shenanigans
		letter.collision_layer = 0
		letter.collision_mask = 0
		original_letter_position = letter.global_position
	
	whoosh.play()


# Show the score granted by a letter
func set_score(new_score):
	score = new_score
	
	if score_mesh.position.z != score_mesh_start_z:
		var tween = get_tree().create_tween()
		@warning_ignore("return_value_discarded")
		tween.tween_property(score_mesh, "position", Vector3(0, 0, score_mesh_start_z), action_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		await tween.finished
	
	var mesh = TextMesh.new()
	
	mesh.font = preload("res://resources/FredokaOne-Regular.ttf")
	mesh.font_size = 70
	
	if score == null:
		mesh.text = "X"
	else:
		mesh.text = String.num_int64(new_score)
	
	score_mesh.mesh = mesh
	
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_property(score_mesh, "position", Vector3(0, 0, 1.2), action_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _physics_process(delta):
	if time != null:
		do_launch_transformation()
		
		time += delta
		
		if time > action_time:
			time = null


func do_launch_transformation():
	var t = time / action_time
	
	var lerp_amt = Tweening.smooth_up_and_down(t)
	
	self.position = lerp(Vector3(original_x, 0, 0), launch_vector + Vector3(original_x, 0, 0), lerp_amt)
	
	var global_launch_vector = self.to_global(launch_vector) - self.global_position
	
	if letter != null && t < launch_curve_inflection_point:
		var lerp_amt_derivative = Tweening.smooth_up_and_down_derivative(t) / action_time
		
		# Manually set the position and velocity, making the physics engine do this is unreliable
		letter.linear_velocity = global_launch_vector * lerp_amt_derivative
		letter.global_position = original_letter_position + lerp(Vector3(0, 0, 0), global_launch_vector, lerp_amt)
	
	# Pull the score back in
	if t > 0.5:
		score_mesh.position.z = lerp(1.5, 0.334, Tweening.smoothify((t - 0.5) * 2))


# When the platform starts slowing down rather than speeding up
# Calculated by finding the first point after t = 0 where the second derivative of smooth_up_and_down is zero (I made my graphing calculator do it for me)
# The letters are unglued from the platform when this time is reached
var launch_curve_inflection_point = 0.234
