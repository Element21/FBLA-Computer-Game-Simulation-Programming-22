extends BoxContainer

class_name LevelData


var max_leaderboard_entries = 10


var level_idx = null
var level_scene = null

export(NodePath) onready var level_label = get_node(level_label) as Label
export(NodePath) onready var highscore_label = get_node(highscore_label) as Label
export(NodePath) onready var play_button = get_node(play_button) as Button
export(NodePath) onready var leaderboard_names = get_node(leaderboard_names) as VBoxContainer
export(NodePath) onready var leaderboard_scores = get_node(leaderboard_scores) as VBoxContainer


func _ready():
	self.hide()
	
	play_button.connect("button_down", self, "play")


func select_level(idx: int, name: String, scene: PackedScene):
	level_idx = idx
	level_scene = scene
	
	level_label.text = name
	
	var highscore = LeaderboardManager.highscore_for(idx)
	
	if highscore == null:
		highscore_label.text = ""
	else:
		highscore_label.text = "Your highscore: " + String(highscore)
	
	var leaderboard_entries = LeaderboardManager.leaderboard_data.get_sorted_leaderboard_for(level_idx)
	
	for i in range(0, min(max_leaderboard_entries, leaderboard_entries.size())):
		var name_label = Label.new()
		name_label.text = leaderboard_entries[i][0]
		leaderboard_names.add_child(name_label)
		
		var score_label = Label.new()
		score_label.text = String(leaderboard_entries[i][1])
		leaderboard_scores.add_child(score_label)
	
	self.show()


func play():
	var status = get_tree().change_scene_to(level_scene)
	
	Music.end_ambience()
	
	assert(status == OK)
