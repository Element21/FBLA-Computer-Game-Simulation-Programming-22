extends Control

class_name LevelData


var max_leaderboard_entries = 10


var level_idx = null
var level_scene = null


onready var highscore_label = get_node("Highscore") as Label
onready var leaderboard = get_node("Leaderboard") as Leaderboard
onready var image_container = get_node("../ImageContainer") as AspectRatioContainer
onready var image = image_container.get_node("TextureRect") as TextureRect

var images = [
	preload("res://Levels/Main Menu/Level 1.png"),
	preload("res://Levels/Main Menu/Level 2.png"),
	preload("res://Levels/Main Menu/Level 3.png"),
	preload("res://Levels/Main Menu/Level 4.png"),
	preload("res://Levels/Main Menu/Level 5.png"),
]


func _ready():
	self.hide()


func select_level(level_idx: int, name: String, scene: PackedScene):
	level_scene = scene
	
	var highscore = LeaderboardManager.get_highscore_for(level_idx)
	
	if highscore == null:
		highscore_label.text = ""
	else:
		highscore_label.text = "Your highscore: " + String(highscore)
	
	# AspectRatioContainer doesn't expand to the same size as its child so I have to do this
	image_container.rect_min_size.x = image.rect_size.x
	image.texture = images[level_idx]
	
	leaderboard.show_leaderboard_for(level_idx)
	
	self.show()


func play_button_clicked():
	var status = get_tree().change_scene_to(level_scene)
	
	Music.end_ambience()
	
	assert(status == OK)

