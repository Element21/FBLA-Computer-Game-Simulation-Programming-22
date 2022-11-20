extends RigidBody


var action_time = 1

var time = 0
var action = null


func flip():
	time = 0
	action = "flip"


func launch():
	time = 0
	action = "launch"


func _process(delta):
	
	if action == "flip":
		do_flip()
	else:
		dont_do_flip()
	
	if action == "launch":
		do_launch()
	else:
		dont_do_launch()
	
	if action != null:
		
		time += delta
		
		if time > action_time:
			action = null


func do_flip():
	self.rotation_degrees.x = lerp(0, -360, Utils.smoothify(time / action_time))

func dont_do_flip():
	self.rotation_degrees.x = 0


func jerky_launch_curve(t):
	return -4*t*t+4*t

func launch_curve(t):
	return jerky_launch_curve(Utils.smoothify(t))


func launch_curve_derivative(t):
	return -24 * t * (t - 1) * (4*t*t*t - 6*t*t + 1)


func do_launch():
	self.linear_velocity = Vector3(0, 5, -2) * launch_curve_derivative(time)

func dont_do_launch():
	self.translation.y = 0
	self.translation.z = 0
