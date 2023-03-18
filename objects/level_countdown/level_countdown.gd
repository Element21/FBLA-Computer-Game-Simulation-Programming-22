extends Node3D

class_name LevelCountdown

signal started


var distance_from_camera = 5

var time = 3

@onready var counter_mesh: MeshInstance3D = %"Counter mesh"
@onready var click_sound: AudioStreamPlayer = %"Click sound"


func start(camera: Camera3D):
	# Move it in front of the camera
	var camera_normal = camera.project_ray_normal(get_window().size / 2)
	self.global_position = camera.global_position + camera_normal * distance_from_camera
	self.rotation = camera.rotation
	
	while time != 0:
		(counter_mesh.mesh as TextMesh).text = String.num_int64(time)
		click_sound.play()
		
		time -= 1
		
		await get_tree().create_timer(1.).timeout
	
	
	counter_mesh.hide()
	click_sound.play()
	
	assert(OK == emit_signal("started"))
