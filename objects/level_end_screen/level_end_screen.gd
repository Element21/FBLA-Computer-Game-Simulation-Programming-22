extends SubViewportContainer

class_name LevelEndScreen

@export var level_index: int
@export var next_level: PackedScene


func _ready():
	self.hide()
	
	# Prevent buttons from being clicked on in game (even though they're already hidden, idk)
	%"Main menu button".hide()
	%"Next level button".hide()


func level_ended(score: int):
	%"Score label".text = String.num_int64(score)
	
	%Leaderboard.show_leaderboard_for(level_index)
	
	self.show()
	%"Main menu button".show()
	
	if next_level:
		%"Next level button".show()


func go_to_main_menu():
	var status = get_tree().change_scene_to_file("res://Levels/Main Menu/main_menu.tscn")
	assert(status == OK)
	
	Music.start_ambience()


func go_to_next_level():
	var status = get_tree().change_scene_to_packed(next_level)
	assert(status == OK)
