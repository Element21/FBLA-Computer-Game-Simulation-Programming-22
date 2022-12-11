extends ViewportContainer

class_name LevelEndScreen


export(PackedScene) var next_level

export(NodePath) onready var main_menu_button = get_node(main_menu_button) as Button
export(NodePath) onready var next_level_button = get_node(next_level_button) as Button
export(NodePath) onready var score_label = get_node(score_label) as Label

func _ready():
	self.hide()
	
	# Prevent buttons from being clicked on (even though they're hidden by the root thing, idk)
	main_menu_button.hide()
	next_level_button.hide()


func level_ended(score: int):
	score_label.text = String(score)
	
	self.show()
	main_menu_button.show()
	
	if next_level:
		next_level_button.show()


func main_menu():
	var status = get_tree().change_scene("res://Levels/Main Menu/main_menu.tscn")
	assert(status == OK)
	
	Music.start_ambience()


func next_level():
	var status = get_tree().change_scene_to(next_level)
	assert(status == OK)
