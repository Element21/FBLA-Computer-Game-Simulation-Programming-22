extends BoxContainer

class_name LevelData


var max_leaderboard_entries = 10


var level_idx = null
var level_scene = null

onready var level_label = get_node("Level label") as Label
onready var highscore_label = get_node("Highscore") as Label
onready var leaderboard = get_node("Leaderboard") as Leaderboard


func _ready():
	self.hide()


func select_level(level_idx: int, name: String, scene: PackedScene):
	level_scene = scene
	
	level_label.text = name
	
	var highscore = LeaderboardManager.highscore_for(level_idx)
	
	if highscore == null:
		highscore_label.text = ""
	else:
		highscore_label.text = "Your highscore: " + String(highscore)
	
	leaderboard.show_leaderboard_for(level_idx)
	
	self.show()


func play():
	var status = get_tree().change_scene_to(level_scene)
	
	Music.end_ambience()
	
	assert(status == OK)
