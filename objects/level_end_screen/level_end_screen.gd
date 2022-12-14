extends ViewportContainer

class_name LevelEndScreen

export(int) var level_index
export(PackedScene) var next_level

export(NodePath) onready var main_menu_button = get_node(main_menu_button) as Button
export(NodePath) onready var next_level_button = get_node(next_level_button) as Button
export(NodePath) onready var score_label = get_node(score_label) as Label
export(NodePath) onready var leaderboard = get_node(leaderboard) as Leaderboard

func _ready():
	self.hide()
	
	# Prevent buttons from being clicked on in game (even though they're already hidden, idk)
	main_menu_button.hide()
	next_level_button.hide()


func level_ended(score: int):
	score_label.text = String(score)
	
	leaderboard.show_leaderboard_for(level_index)
	
	self.show()
	main_menu_button.show()
	
	if next_level:
		next_level_button.show()


func go_to_main_menu():
	var status = get_tree().change_scene("res://Levels/Main Menu/main_menu.tscn")
	assert(status == OK)
	
	Music.start_ambience()


func go_to_next_level():
	var status = get_tree().change_scene_to(next_level)
	assert(status == OK)
