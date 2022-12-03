extends ViewportContainer

class_name LevelEndScreen


export(PackedScene) var next_level

export(NodePath) onready var next_level_button = get_node(next_level_button) as Button

func _ready():
	self.hide()
	
	if !next_level:
		next_level_button.hide()


func main_menu():
	var status = get_tree().change_scene("res://Levels/Main Menu/main_menu.tscn")
	assert(status == OK)


func next_level():
	var status = get_tree().change_scene(next_level)
	assert(status == OK)
