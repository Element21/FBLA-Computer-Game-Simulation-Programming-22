extends SubViewportContainer

class_name LevelEndScreen

@export var level_index: int
@export var next_level: PackedScene

@onready var main_menu_button: Button = %"Main menu button"
@onready var next_level_button: Button = %"Next level button"

func _ready():
	self.hide()
	
	# Prevent buttons from being clicked on in game (even though they're already hidden, idk)
	main_menu_button.hide()
	next_level_button.hide()


func level_ended(score: int):
	(%"Score label" as Label).text = String.num_int64(score)
	
	(%Leaderboard as Leaderboard).show_leaderboard_for(level_index)
	
	self.show()
	main_menu_button.show()
	
	if next_level:
		next_level_button.show()


func go_to_main_menu():
	var status = get_tree().change_scene_to_file("res://Levels/3D Main Menu/3d_main_menu.tscn")
	assert(status == OK)
	
	Music.start_ambience()


func go_to_next_level():
	var status = get_tree().change_scene_to_packed(next_level)
	assert(status == OK)
