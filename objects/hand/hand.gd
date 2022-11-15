# Soup must be on collision layer 2

extends Spatial

export(NodePath) onready var camera = get_node(camera) as Camera
export(Vector2) var arm_pivot = Vector2(-1, -1)

var inverse_arm_response = 0.5

onready var hand: MeshInstance = get_child(0)
onready var raycast: RayCast = get_child(1)

onready var target_pos: Vector3 = hand.translation


func _process(delta):
	
	hand.translation = lerp(hand.translation, target_pos, pow(delta, inverse_arm_response))
	
	hand.rotation.y = -Vector2(hand.translation.x, hand.translation.z).angle_to_point(arm_pivot) - PI / 2
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = camera.project_ray_normal(mouse_pos) * 1000
	
	raycast.cast_to = to - self.translation
	raycast.translation = from - self.translation

	if raycast.is_colliding():
		
		target_pos = raycast.get_collision_point() + Vector3(0, 2, 0) - self.translation
		

	
	pass
