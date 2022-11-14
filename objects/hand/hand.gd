# Soup must be on collision layer 2

extends Node

export(NodePath) onready var camera = get_node(camera) as Camera
export(Vector2) var arm_pivot = Vector2(-1, -1)

var raycast: RayCast
var hand: MeshInstance


func _ready():
	
	hand = get_child(0)
	raycast = get_child(1)


func _process(delta):
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = camera.project_ray_normal(mouse_pos) * 1000
	
	raycast.cast_to = to
	raycast.translation = from

	if raycast.is_colliding():
		
		hand.translation = raycast.get_collision_point() + Vector3(0, 2, 0)
		
		hand.rotation.y = -Vector2(hand.translation.x, hand.translation.z).angle_to_point(arm_pivot) - PI / 2
	
	pass
