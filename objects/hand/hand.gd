# Soup must be on collision layer 2

extends Node3D

class_name Hand

@export var word_manager: WordManager
@export var level: Level
@export var arm_pivot: Vector2 = Vector2(-2, 35)

var hand_height = 2
var drop_height = 3

var arm_response = 5

var hand_animation_part_time = 0.5


var hand_animation_frames = [
	preload("res://resources/hand_frames/frame1_hand_3.0.obj"),
	preload("res://resources/hand_frames/frame2_hand_3.0.obj"),
	preload("res://resources/hand_frames/frame3_hand_3.0.obj"),
	preload("res://resources/hand_frames/frame4_hand_3.0.obj"),
	preload("res://resources/hand_frames/frame5_hand_3.0.obj"),
]
var current_hand_animation_frame = 0

@onready var hand: MeshInstance3D = %Hand
@onready var raycast: RayCast3D = %Raycast
@onready var hand_animation_state_interval: Timer = %"Hand animation state interval"
@onready var target_pos: Vector3 = hand.position

enum GRABBING_STATE { NOT, DIPPING, PULLING, DROPPING }

var grabbing_state = GRABBING_STATE.NOT

# For hand animation
var start_hand_translation
var final_hand_translation
var time = 0
var letter_being_grabbed = null


func _ready():
	fix_arm_rotation()


# Check if the mouse is pointing at the surface of soup
func pointing_at_valid_soup_surface() -> bool:
	if !raycast.is_colliding():
		return false
	
	var normal = raycast.get_collision_normal()
	
	# Make sure the soup is flat, the side of the soup should be invisible
	# Allows for margin of error because normal calculations aren't perfect
	return abs(normal.x) < 0.01 && abs(normal.z) < 0.01


func _input(event: InputEvent):
	if event.is_action_pressed("click") && pointing_at_valid_soup_surface() && !word_manager.no_spots_left() && grabbing_state == GRABBING_STATE.NOT:
		grabbing_state = GRABBING_STATE.DIPPING
		
		start_hand_translation = hand.position
		final_hand_translation = hand.position - Vector3(0, hand_height, 0)
		
		delayed_hand_animation()


func delayed_hand_animation():
	await get_tree().create_timer(0.25).timeout
	start_hand_animation()


func start_hand_animation():
	hand_animation_state_interval.start()


# Progress the animation of the hand opening and closing
func next_hand_animation_frame():
	if grabbing_state == GRABBING_STATE.DIPPING:
		current_hand_animation_frame += 1
	elif grabbing_state == GRABBING_STATE.DROPPING || grabbing_state == GRABBING_STATE.PULLING:
		current_hand_animation_frame -= 1
	
	if current_hand_animation_frame == 0 || current_hand_animation_frame == hand_animation_frames.size() - 1:
		hand_animation_state_interval.stop()
	
	hand.mesh = hand_animation_frames[current_hand_animation_frame]


func next_grabbing_state():
	if grabbing_state == GRABBING_STATE.DIPPING:
		done_dipping()
		
	elif grabbing_state == GRABBING_STATE.PULLING:
		done_pulling()
		
	elif grabbing_state == GRABBING_STATE.DROPPING:
		done_dropping()


func _process(delta: float):
	if !level.playing:
		return
	
	if grabbing_state == GRABBING_STATE.NOT:
		move_hand_towards_mouse(delta)
	
	if time >= hand_animation_part_time:
		time = 0
		
		next_grabbing_state()
	
	# Make sure the letter stays in the hand when grabbing
	if (grabbing_state == GRABBING_STATE.PULLING || grabbing_state == GRABBING_STATE.DROPPING) && letter_being_grabbed:
		letter_being_grabbed.global_position = hand.global_position
	
	# Progress the hand animation
	if grabbing_state != GRABBING_STATE.NOT:
		time += delta
		
		hand.position = lerp(start_hand_translation, final_hand_translation, Tweening.smoothify(time / hand_animation_part_time))
	
	fix_arm_rotation()


# Change the angle of the arm such that it pivots around point
# This makes the arm look like an arm because arms pivot around a point in real life
func fix_arm_rotation():
	var top_down_position = Vector2(hand.position.x, hand.position.z)
	var arm_pivot_position_local = arm_pivot - Vector2(self.position.x, self.position.y)
	
	hand.rotation.y = -top_down_position.angle_to_point(arm_pivot_position_local) + PI / 2


func move_hand_towards_mouse(delta: float):
	hand.position += (target_pos - hand.position) * arm_response * delta
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var from = level.camera.project_ray_origin(mouse_pos)
	var to = level.camera.project_ray_normal(mouse_pos) * 1000
	
	raycast.target_position = level.camera.project_local_ray_normal(mouse_pos) * 1000
	
	if pointing_at_valid_soup_surface():
		target_pos = raycast.get_collision_point() + Vector3(0, hand_height, 0) - self.position


func done_dipping():
	grabbing_state = GRABBING_STATE.PULLING
		
	(%Particles as GPUParticles3D).emitting = true
	
	(%Slap as AudioStreamPlayer3D).play()
	
	var tmp = start_hand_translation
	start_hand_translation = final_hand_translation
	final_hand_translation = tmp
	
	letter_being_grabbed = letter_to_be_picked_up()
	
	if letter_being_grabbed:
		(letter_being_grabbed as Letter).freeze = true
		(letter_being_grabbed as Letter).remove_from_group("Letters")
	else:
		%AudioStreamPlayer.play()
		start_hand_animation()


func done_pulling():
	if letter_being_grabbed:
		grabbing_state = GRABBING_STATE.DROPPING
		
		var local_drop_pos = self.to_local(word_manager.next_platform_position())
		
		start_hand_translation = hand.position
		final_hand_translation = local_drop_pos + Vector3(0, drop_height, 0)
		
		delayed_hand_animation()
	
	else:
		grabbing_state = GRABBING_STATE.NOT


func done_dropping():
	if letter_being_grabbed:
		letter_being_grabbed.freeze = false
		word_manager.place_letter(letter_being_grabbed)
		letter_being_grabbed = null
	
	grabbing_state = GRABBING_STATE.NOT


# Get the letter the hand should pick up
func letter_to_be_picked_up() -> Letter:
	var min_distance = INF
	var closest_letter = null
		
	for letter in get_tree().get_nodes_in_group("Letters"):
		# Make sure the letter is inside the hand
		if (%"Letter pickup area" as Area3D).overlaps_body(letter):
			var distance = hand.global_position.distance_to((letter as Letter).global_position)
			
			if distance < min_distance:
				min_distance = distance
				closest_letter = letter
	
	return closest_letter


func letter_deleted():
	if grabbing_state == GRABBING_STATE.DROPPING:
		var t = Tweening.smoothify(time / hand_animation_part_time)
		final_hand_translation = self.to_local(word_manager.next_platform_position()) + Vector3(0, drop_height, 0)
		# Move the start position such that the hand can change direction without jumping
		start_hand_translation = (hand.position - t * final_hand_translation) / (1 - t)


