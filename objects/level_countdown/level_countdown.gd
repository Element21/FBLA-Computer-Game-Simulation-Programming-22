extends Node3D

class_name LevelCountdown

signal started


var distance_from_camera = 5

var time = 3


func start(camera: Camera3D):
	# Move it in front of the camera
	var camera_normal = camera.project_ray_normal(get_viewport().size / 2)
	self.global_translation = camera.global_translation + camera_normal * distance_from_camera
	self.rotation = camera.rotation
	
	%"Counter mesh".mesh.text = "3"
	
	%"Click sound".play()
	
	%Timer.start()


func timeout():
	time -= 1
	
	%"Counter mesh".mesh.text = String.num_int64(time)
	
	if time == 0:
		%"Counter mesh".hide()
		
		emit_signal("started")
		
		%Timer.stop()
	else:
		%"Click sound".play()
