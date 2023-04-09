extends Node


var start_pos = Vector3(5, 3.5, 7)
var can_offset = Vector3(0, 3, 4)
var maybe_can_focusing_on = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	
	%RayCast.global_position = %Camera.global_position
	%RayCast.target_position = %Camera.project_ray_normal(mouse_pos) * 1000



func _input(event: InputEvent):
	if event.is_action_pressed("click"):
		var raycast_hit = %RayCast.get_collider()
		
		if raycast_hit == null:
			var tween = get_tree().create_tween()
			tween.tween_property(%Camera, "position", start_pos, .5).set_trans(Tween.TRANS_SINE)
			unfocus_can()
			return
		
		if raycast_hit is LevelCan:
			unfocus_can()
			
			var can: LevelCan = raycast_hit
			
			var tween = get_tree().create_tween()
			tween.tween_property(%Camera, "position", can.position + can_offset, .5).set_trans(Tween.TRANS_SINE)
			
			can.show_level_data()
			
			maybe_can_focusing_on = can
			
			return
		
		if raycast_hit is PlayButton:
			play_level()
			return


func unfocus_can():
	if maybe_can_focusing_on:
		maybe_can_focusing_on.hide_level_data()
		maybe_can_focusing_on = null


func play_level():
	var can: LevelCan
	
	if maybe_can_focusing_on == null:
		return
	
	can = maybe_can_focusing_on
	
	can.play_can_open_animation()
	
	var tween = get_tree().create_tween()
	tween.tween_method(camera_animation.bind(%Camera.position), 0., 1., 1)
	
	await tween.finished
	
	assert(get_tree().change_scene_to_packed(maybe_can_focusing_on.level_scene) == OK)
	
	Music.end_ambience()


var camera_tilt_down = 24
var slope = tan(camera_tilt_down * PI / 180.) * can_offset.z / can_offset.y
var adjust = 1.6


func camera_animation(t: float, camera_start_position: Vector3):
	# f(t) = 3*slope*t^2 + (1-3*slope-adjust)*t^3 + adjust*t^4 is a solution to f(0)=0, f(1)=1, and lim t->0+ f(t)/Tweening.smoothify(t) = slope
	# This allows the camera to face in the direction of travel without jumping at the beginning because the tangent at the beginning is controlled.
	# "adjust" is a parameter used to make sure the camera doesn't go through the can
	var vec = can_offset * Vector3(0, 3*slope*t*t + (1-3*slope-adjust)*t*t*t + adjust*t*t*t*t, Tweening.smoothify(t))
	
	%Camera.position = camera_start_position - vec
	%Camera.rotation.x = -vec.angle_to(Vector3(0, 0, 1))
