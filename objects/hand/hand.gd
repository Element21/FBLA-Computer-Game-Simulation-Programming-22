# Soup must be on collision layer 2

extends Spatial

export(NodePath) onready var camera = get_node(camera) as Camera
export(Vector2) var arm_pivot = Vector2(2, -15)
export(Vector2) var drop_position = Vector2(0, -5)

var hand_height = 2

var inverse_arm_response = 0.2

var hand_animation_part_time = 0.5

onready var hand: MeshInstance = get_child(0)
onready var raycast: RayCast = get_child(1)

onready var target_pos: Vector3 = hand.translation

enum GRABBING_STATE { NOT, DIPPING, PULLING, DROPPING }

var grabbing_state = GRABBING_STATE.NOT

# For hand animation
var start_hand_translation
var final_hand_translation
var time = 0

func smoothify(t):
	return (-cos(PI * t) + 1) * 0.5


func _input(event):
	
	if event.is_action_pressed("click") && raycast.is_colliding():
		
		grabbing_state = GRABBING_STATE.DIPPING
		
		start_hand_translation = hand.translation
		final_hand_translation = hand.translation - Vector3(0, hand_height, 0)


func _process(delta):
	
	if grabbing_state == GRABBING_STATE.NOT:
		
		hand.translation += (target_pos - hand.translation) / inverse_arm_response * delta
	
		var mouse_pos = get_viewport().get_mouse_position()
		
		var from = camera.project_ray_origin(mouse_pos)
		var to = camera.project_ray_normal(mouse_pos) * 1000
		
		raycast.cast_to = to - self.translation
		raycast.translation = from - self.translation

		if raycast.is_colliding():
			
			target_pos = raycast.get_collision_point() + Vector3(0, hand_height, 0) - self.translation
	
	if time >= hand_animation_part_time:
		time = 0
		
		if grabbing_state == GRABBING_STATE.DIPPING:
			grabbing_state = GRABBING_STATE.PULLING
			
			var tmp = start_hand_translation
			start_hand_translation = final_hand_translation
			final_hand_translation = tmp
		
		elif grabbing_state == GRABBING_STATE.PULLING:
				grabbing_state = GRABBING_STATE.DROPPING
				
				var local_drop_pos = drop_position - Vector2(self.translation.x, self.translation.z)
				
				start_hand_translation = hand.translation
				final_hand_translation = Vector3(local_drop_pos.x, hand_height, local_drop_pos.y)
		
		elif grabbing_state == GRABBING_STATE.DROPPING:
				grabbing_state = GRABBING_STATE.NOT
	
	if grabbing_state != GRABBING_STATE.NOT:
		
		time += delta
		
		hand.translation = lerp(start_hand_translation, final_hand_translation, smoothify(time / hand_animation_part_time))
	
	hand.rotation.y = -Vector2(hand.translation.x, hand.translation.z).angle_to_point(arm_pivot - Vector2(self.translation.x, self.translation.y)) - PI / 2
