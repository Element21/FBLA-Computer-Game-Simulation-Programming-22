extends Control

class_name LevelData


var max_leaderboard_entries = 10
var leaderboard_entry_horizontal_spacing = 10
var leaderboard_entry_vertical_separation = 30


var level_idx = null
var level_scene = null

onready var level_label: Label = get_child(0)
onready var highscore_label: Label = get_child(1)
onready var play_button: Button = get_child(2)
onready var leaderboard: Control = get_child(3)


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
		name_label.align = Label.ALIGN_RIGHT
		name_label.grow_horizontal = Control.GROW_DIRECTION_BEGIN
		name_label.text = leaderboard_entries[i][0]
		name_label.rect_position.x = -leaderboard_entry_horizontal_spacing / 2
		name_label.rect_position.y = leaderboard_entry_vertical_separation * i
		leaderboard.add_child(name_label)
		
		var score_label = Label.new()
		score_label.align = Label.ALIGN_LEFT
		score_label.align = Control.GROW_DIRECTION_END
		score_label.text = String(leaderboard_entries[i][1])
		score_label.rect_position.x = leaderboard_entry_horizontal_spacing / 2
		score_label.rect_position.y = leaderboard_entry_vertical_separation * i
		leaderboard.add_child(score_label)
	
	self.show()


func play():
	var status = get_tree().change_scene_to(level_scene)
	
	assert(status == OK)
