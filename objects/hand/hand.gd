# Soup must be on collision layer 2

extends Spatial

export(NodePath) onready var camera = get_node(camera) as Camera
export(NodePath) onready var word_manager = get_node(word_manager) as WordManager
export(Vector2) var arm_pivot = Vector2(2, -15)

var hand_height = 2

var inverse_arm_response = 0.2

var hand_animation_part_time = 0.5

onready var hand: MeshInstance = get_child(0)
onready var raycast: RayCast = get_child(1)
onready var letter_pickup_area: Area = hand.get_child(1)

onready var target_pos: Vector3 = hand.translation

enum GRABBING_STATE { NOT, DIPPING, PULLING, DROPPING }

var grabbing_state = GRABBING_STATE.NOT

# For hand animation
var start_hand_translation
var final_hand_translation
var time = 0
var letter_being_grabbed = null


func _input(event):
	
	if event.is_action_pressed("click") && raycast.is_colliding():
		
		grabbing_state = GRABBING_STATE.DIPPING
		
		start_hand_translation = hand.translation
		final_hand_translation = hand.translation - Vector3(0, hand_height, 0)


func progress_grabbing_state():
	
	if grabbing_state == GRABBING_STATE.DIPPING:
		grabbing_state = GRABBING_STATE.PULLING
		
		var tmp = start_hand_translation
		start_hand_translation = final_hand_translation
		final_hand_translation = tmp
		
		var min_distance = INF
		
		for letter in LetterManager.letters_in_play:
			
			if letter_pickup_area.overlaps_body(letter):
				
				var distance = hand.global_translation.distance_to(letter.global_translation)
				
				if distance < min_distance:
					
					min_distance = distance
					letter_being_grabbed = letter
		
		if letter_being_grabbed:
			
			letter_being_grabbed.mode = RigidBody.MODE_KINEMATIC
			LetterManager.remove_from_play(letter_being_grabbed)
		
	elif grabbing_state == GRABBING_STATE.PULLING:
		if letter_being_grabbed:
			grabbing_state = GRABBING_STATE.DROPPING
			
			var local_drop_pos = word_manager.next_platform_position() - Vector2(self.translation.x, self.translation.z)
			
			start_hand_translation = hand.translation
			final_hand_translation = Vector3(local_drop_pos.x, hand_height, local_drop_pos.y)
		
		else:
			grabbing_state = GRABBING_STATE.NOT
	
	elif grabbing_state == GRABBING_STATE.DROPPING:
		
		if letter_being_grabbed:
			letter_being_grabbed.mode = RigidBody.MODE_RIGID
			word_manager.drop_letter(letter_being_grabbed)
			letter_being_grabbed = null
		
		grabbing_state = GRABBING_STATE.NOT


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
		
		progress_grabbing_state()
	
	if (grabbing_state == GRABBING_STATE.PULLING || grabbing_state == GRABBING_STATE.DROPPING) && letter_being_grabbed:
		
		letter_being_grabbed.global_translation = hand.global_translation
	
	if grabbing_state != GRABBING_STATE.NOT:
		
		time += delta
		
		hand.translation = lerp(start_hand_translation, final_hand_translation, Utils.smoothify(time / hand_animation_part_time))
	
	hand.rotation.y = -Vector2(hand.translation.x, hand.translation.z).angle_to_point(arm_pivot - Vector2(self.translation.x, self.translation.y)) - PI / 2
