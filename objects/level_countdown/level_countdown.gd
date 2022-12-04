extends Spatial

class_name LevelCountdown

signal started


var distance_from_camera = 5

onready var mesh_instance = get_child(0)
onready var timer = get_child(1)

var time = 3


func start(camera: Camera):
	var camera_normal = camera.project_ray_normal(get_viewport().size / 2)
	
	self.global_translation = camera.global_translation + camera_normal * distance_from_camera
	
	self.rotation = camera.rotation
	
	timer.start()


func timeout():
	time -= 1
	
	mesh_instance.mesh.text = String(time)
	
	if time == 0:
		mesh_instance.hide()
		
		emit_signal("started")
		
		timer.stop()
