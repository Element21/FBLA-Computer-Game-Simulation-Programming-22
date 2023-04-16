extends Area3D

class_name LevelCan

# https://github.com/godotengine/godot-demo-projects/tree/master/viewport/2d_in_3d

@onready var level_data_viewport: SubViewport = %"Level data viewport"
@onready var play_button_viewport: SubViewport = %"Play button viewport"
@onready var highscore_label: Label = %Highscore
@onready var popup: Node3D = %Popup
@onready var animation_player: AnimationPlayer = can.find_child("AnimationPlayer")
@onready var start_pos = self.position

@export var level_idx: int
@export var level_scene: PackedScene
@export var can: Node3D

static func come_out_amt() -> Vector3: return Vector3(0, 0, 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	if !LeaderboardManager.is_level_unlocked(level_idx):
		self.hide()
		self.collision_layer = 0
		(%PlayButton as Area3D).collision_layer = 0
		return

	assert(animation_player != null)
	
	(%Leaderboard as Leaderboard).show_leaderboard_for(level_idx)
	
	level_data_viewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	
	var level_data_material = StandardMaterial3D.new()
	level_data_material.albedo_texture = level_data_viewport.get_texture()
	level_data_material.emission_enabled = true
	level_data_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	(%ViewportQuad as MeshInstance3D).set_surface_override_material(0, level_data_material)
	
	play_button_viewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	
	var play_button_material = StandardMaterial3D.new()
	play_button_material.albedo_texture = play_button_viewport.get_texture()
	play_button_material.emission_enabled = true
	play_button_material.emission_texture = play_button_viewport.get_texture()
	level_data_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	(%PlayButtonQuad as MeshInstance3D).set_surface_override_material(0, play_button_material)
	
	(%"Level name" as Label).text = "Level " + String.num_int64(level_idx + 1)
	
	var highscore = LeaderboardManager.get_highscore_for(level_idx)
	
	if highscore == null:
		highscore_label.text = ""
	else:
		highscore_label.text = "Your highscore: " + String.num_int64(highscore)
	


func show_level_data():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.set_parallel()
	@warning_ignore("return_value_discarded")
	tween.tween_property(popup, "position", Vector3(0, 7.5, -2.8), 0.5).set_trans(Tween.TRANS_SINE)
	@warning_ignore("return_value_discarded")
	tween.tween_property(self, "position", start_pos + LevelCan.come_out_amt(), 0.5).set_trans(Tween.TRANS_SINE)


func hide_level_data():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.set_parallel()
	@warning_ignore("return_value_discarded")
	tween.tween_property(popup, "position", Vector3(0, 20, -2.8), 0.5).set_trans(Tween.TRANS_SINE)
	@warning_ignore("return_value_discarded")
	tween.tween_property(self, "position", start_pos, 0.5).set_trans(Tween.TRANS_SINE)


func play_can_open_animation():
	# I can't play two animations at once, so I have to do this
	# I tried using an AnimationTree but that didn't work. This works just as well though.
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_property(can.find_child("Can Top"), "blend_shapes/Can Top.001", 1, 1.)
	
	animation_player.play("Open TabAction001")
