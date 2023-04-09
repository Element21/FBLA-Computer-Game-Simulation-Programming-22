extends Area3D

class_name LevelCan

# https://github.com/godotengine/godot-demo-projects/tree/master/viewport/2d_in_3d

@export var level_idx: int
@export var level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	%"Level data viewport".set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	
	var level_data_material = StandardMaterial3D.new()
	level_data_material.albedo_texture = %"Level data viewport".get_texture()
	
	%ViewportQuad.set_surface_override_material(0, level_data_material)
	
	%"Play button viewport".set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	
	var play_button_material = StandardMaterial3D.new()
	play_button_material.albedo_texture = %"Play button viewport".get_texture()
	
	%PlayButtonQuad.set_surface_override_material(0, play_button_material)
	
	%"Level name".text = "Level " + String.num_int64(level_idx + 1)
	
	var highscore = LeaderboardManager.get_highscore_for(level_idx)
	
	if highscore == null:
		%Highscore.text = ""
	else:
		%Highscore.text = "Your highscore: " + String.num_int64(highscore)
	


func show_level_data():
	var tween = get_tree().create_tween()
	tween.tween_property(%Popup, "position", Vector3(0, 7.5, -2.8), 0.5).set_trans(Tween.TRANS_SINE)


func hide_level_data():
	var tween = get_tree().create_tween()
	tween.tween_property(%Popup, "position", Vector3(0, -7.5, -2.8), 0.5).set_trans(Tween.TRANS_SINE)
