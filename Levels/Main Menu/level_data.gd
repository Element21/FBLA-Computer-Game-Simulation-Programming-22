extends Control

class_name LevelData


var max_leaderboard_entries = 10

var level_scene = null


var images = [
	preload("res://Levels/Main Menu/Level 1.png"),
	preload("res://Levels/Main Menu/Level 2.png"),
	preload("res://Levels/Main Menu/Level 3.png"),
	preload("res://Levels/Main Menu/Level 4.png"),
	preload("res://Levels/Main Menu/Level 5.png"),
]

@onready var highscore_label = %Highscore as Label
@onready var image = %Image as TextureRect


func _ready():
	self.hide()


func select_level(level_idx: int, scene: PackedScene):
	level_scene = scene
	
	var highscore = LeaderboardManager.get_highscore_for(level_idx)
	
	if highscore == null:
		highscore_label.text = ""
	else:
		highscore_label.text = "Your highscore: " + String.num_int64(highscore)
	
	# AspectRatioContainer doesn't expand to the same size as its child so I have to do this
	(%ImageContainer as AspectRatioContainer).custom_minimum_size.x = image.size.x
	image.texture = images[level_idx]
	
	(%Leaderboard as Leaderboard).show_leaderboard_for(level_idx)
	
	self.show()


func play_button_clicked():
	var status = get_tree().change_scene_to_packed(level_scene)
	
	Music.end_ambience()
	
	assert(status == OK)

