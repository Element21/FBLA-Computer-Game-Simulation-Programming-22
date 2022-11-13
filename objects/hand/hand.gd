# Soup must be on collision layer 2

extends Node

export(NodePath) onready var camera = get_node(camera) as Camera

var raycast: RayCast


func _ready():
	
	raycast = get_child(0)


func _process(delta):
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from = camera.project_ray_origin(mouse_pos) - self.translation
	var to = camera.project_ray_normal(mouse_pos) * 1000 - self.translation

	raycast.cast_to = to
	raycast.translation = from

	if raycast.is_colliding():
		
		print(raycast.get_collider(), raycast.get_collision_point())
		self.translation = raycast.get_collision_point() + Vector3(0, 1, 0)
	
	pass
