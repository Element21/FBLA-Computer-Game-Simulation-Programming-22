extends Area3D

class_name LevelCan

# https://github.com/godotengine/godot-demo-projects/tree/master/viewport/2d_in_3d

@export var level_idx: int
@export var level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	%SubViewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	
	var material = StandardMaterial3D.new()
	material.albedo_texture = %SubViewport.get_texture()
	
	%ViewportQuad.set_surface_override_material(0, material)
	
	%"Level name".text = "Level " + String.num_int64(level_idx + 1)
	
	var highscore = LeaderboardManager.get_highscore_for(level_idx)
	
	if highscore == null:
		%Highscore.text = ""
	else:
		%Highscore.text = "Your highscore: " + String.num_int64(highscore)


func show_level_data():
	var tween = get_tree().create_tween()
	tween.tween_property(%ViewportQuad, "position", Vector3(0, 7, -2.8), 0.5).set_trans(Tween.TRANS_SINE)


func hide_level_data():
	var tween = get_tree().create_tween()
	tween.tween_property(%ViewportQuad, "position", Vector3(0, -7, -2.8), 0.5).set_trans(Tween.TRANS_SINE)
