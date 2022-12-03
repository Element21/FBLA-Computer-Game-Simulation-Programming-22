extends ViewportContainer

class_name LevelEndScreen


export(PackedScene) var next_level

onready var viewport = get_child(0)
onready var ui = viewport.get_child(0)
onready var next_level_button = ui.get_child(3)

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
