extends SubViewportContainer

class_name LevelEndScreen

@export var level_index: int
@export var transition: Transition

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
	
	var next_level = Levels.get_by_index(level_index + 1)
	
	if next_level:
		next_level_button.show()


func go_to_main_menu():
	transition.change_scene(load("res://levels/3D Main Menu/3d_main_menu.tscn"))


func retry_level():
	transition.change_scene(Levels.get_by_index(level_index))


func go_to_next_level():
	transition.change_scene(Levels.get_by_index(level_index + 1))

