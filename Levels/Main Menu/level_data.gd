extends Control

class_name LevelData


var level_idx = null
var level_scene = null

onready var level_label: Label = get_child(0)
onready var highscore_label: Label = get_child(1)
onready var play_button: Button = get_child(2)


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
	
	self.show()


func play():
	var status = get_tree().change_scene_to(level_scene)
	
	assert(status == OK)
