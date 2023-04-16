extends Node


@onready var camera: Camera3D = %Camera
@onready var spotlight: SpotLight3D = %Spotlight
@onready var raycast: RayCast3D = %RayCast

@onready var camera_start_pos = camera.global_position
var camera_can_offset = Vector3(0, 3, 4)

@export var spotlight_sample_can: LevelCan
@onready var spotlight_can_offset = spotlight.global_position - spotlight_sample_can.global_position
@onready var spotlight_energy = spotlight.light_energy

var maybe_can_focusing_on = null


# Called when the node enters the scene tree for the first time.
func _ready():
	spotlight.light_energy = 0.
	Music.play(MusicPlayer.Song.LocalForecast)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	
	raycast.global_position = camera.global_position
	raycast.target_position = camera.project_local_ray_normal(mouse_pos) * 1000
	
	var raycast_hit = raycast.get_collider()
	
	if maybe_can_focusing_on == null && raycast_hit is LevelCan:
		point_spotlight_at(raycast_hit)


func _input(event: InputEvent):
	if event.is_action_pressed("click"):
		var raycast_hit = raycast.get_collider()
		
		if raycast_hit == null:
			var tween = get_tree().create_tween()
			@warning_ignore("return_value_discarded")
			tween.tween_property(camera, "position", camera_start_pos, .5).set_trans(Tween.TRANS_SINE)
			unfocus_can()
			return
		
		if raycast_hit is LevelCan:
			unfocus_can()
			
			var can: LevelCan = raycast_hit
			
			point_spotlight_at(can)
			
			var tween = get_tree().create_tween()
			@warning_ignore("return_value_discarded")
			tween.tween_property(camera, "position", can.position + camera_can_offset + LevelCan.come_out_amt(), .5).set_trans(Tween.TRANS_SINE)
			
			can.show_level_data()
			
			maybe_can_focusing_on = can
			
			return
		
		if raycast_hit is PlayButton:
			play_level()
			return


func unfocus_can():
	if maybe_can_focusing_on is LevelCan:
		(maybe_can_focusing_on as LevelCan).hide_level_data()
		
		maybe_can_focusing_on = null


func play_level():
	var can: LevelCan
	
	if maybe_can_focusing_on == null:
		return
	
	can = maybe_can_focusing_on
	
	can.play_can_open_animation()
	
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_method(camera_animation.bind(camera.position), 0., 1., 1.5)
	
	await tween.finished
	await get_tree().create_timer(0.3).timeout
	
	assert(get_tree().change_scene_to_packed(maybe_can_focusing_on.level_scene) == OK)
	


var camera_tilt_down = 19
var slope = tan(camera_tilt_down * PI / 180.) * camera_can_offset.z / camera_can_offset.y
var adjust = 1.6


func camera_animation(t: float, camera_start_position: Vector3):
	# f(t) = 3*slope*t^2 + (1-3*slope-adjust)*t^3 + adjust*t^4 is a solution to f(0)=0, f(1)=1, and lim t->0+ f(t)/Tweening.smoothify(t) = slope
	# This allows the camera to face in the direction of travel without jumping at the beginning because the tangent at the beginning is controlled.
	# "adjust" is a parameter used to make sure the camera doesn't go through the can
	var vec = camera_can_offset*Vector3(0, 3*slope*t*t + (1-3*slope-adjust)*t*t*t + adjust*t*t*t*t, Tweening.smoothify(t))
	
	camera.position = camera_start_position - vec
	camera.rotation.x = -vec.angle_to(Vector3(0, 0, 1))


var maybe_can_spotlit = null

func point_spotlight_at(can: LevelCan):
	if maybe_can_spotlit == can:
		return
	
	maybe_can_spotlit = can
	
	var tween = get_tree().create_tween()
	
	if spotlight.light_energy == 0:
		@warning_ignore("return_value_discarded")
		tween.tween_property(spotlight, "light_energy", spotlight_energy, 0.5).set_trans(Tween.TRANS_SINE)
		spotlight.global_position = can.global_position + spotlight_can_offset
	else:
		@warning_ignore("return_value_discarded")
		tween.tween_property(spotlight, "global_position", can.global_position + spotlight_can_offset, .5).set_trans(Tween.TRANS_SINE)
