extends Spatial

class_name LevelCountdown

signal started


var distance_from_camera = 5

onready var mesh_instance = get_node("MeshInstance")
onready var timer = get_node("Timer")
onready var click_sound = get_node("Click sound")

var time = 3


func start(camera: Camera):
	# Move it in front of the camera
	var camera_normal = camera.project_ray_normal(get_viewport().size / 2)
	self.global_translation = camera.global_translation + camera_normal * distance_from_camera
	self.rotation = camera.rotation
	
	mesh_instance.mesh.text = "3"
	
	click_sound.play()
	
	timer.start()


func timeout():
	time -= 1
	
	mesh_instance.mesh.text = String(time)
	
	if time == 0:
		mesh_instance.hide()
		
		emit_signal("started")
		
		timer.stop()
	else:
		click_sound.play()
