extends Area3D

class_name LevelCan

# https://github.com/godotengine/godot-demo-projects/tree/master/viewport/2d_in_3d

@onready var level_data_viewport: SubViewport = %"Level data viewport"
@onready var play_button_viewport: SubViewport = %"Play button viewport"
@onready var highscore_label: Label = %Highscore
@onready var popup: Node3D = %Popup

@export var level_idx: int
@export var level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	if !LeaderboardManager.is_level_unlocked(level_idx):
		self.hide()
		self.collision_layer = 0
		(%PlayButton as Area3D).collision_layer = 0
		return
	
	level_data_viewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	
	var level_data_material = StandardMaterial3D.new()
	level_data_material.albedo_texture = level_data_viewport.get_texture()
	level_data_material.emission_enabled = true
	level_data_material.emission_texture = level_data_viewport.get_texture()
	
	(%ViewportQuad as MeshInstance3D).set_surface_override_material(0, level_data_material)
	
	play_button_viewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	
	var play_button_material = StandardMaterial3D.new()
	play_button_material.albedo_texture = play_button_viewport.get_texture()
	play_button_material.emission_enabled = true
	play_button_material.emission_texture = play_button_viewport.get_texture()
	
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
	tween.tween_property(popup, "position", Vector3(0, 7.5, -2.8), 0.5).set_trans(Tween.TRANS_SINE)


func hide_level_data():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_property(popup, "position", Vector3(0, -7.5, -2.8), 0.5).set_trans(Tween.TRANS_SINE)


func play_can_open_animation():
	# TODO: Replace this code when I get the actual animation
	(%"Can Mesh" as MeshInstance3D).mesh = preload("res://resources/soupCanopen.obj")
