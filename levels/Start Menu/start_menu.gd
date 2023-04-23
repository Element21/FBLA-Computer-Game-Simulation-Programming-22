extends Control

signal first_play

@onready var transition: Transition = %Transition
@onready var name_input = %"Name input"


func go_to_main_menu(_from_signal):
	var name_given = name_input.text
	
	if name_given == "":
		(%"Empty name error" as Label).visible = true
	else:
		LeaderboardManager.set_player_name(name_given)
		if not LeaderboardManager.is_level_unlocked(1):
			# Assume this is first run, lauch cutscene
			transition.change_scene(load("res://levels/Start Menu/Cutscene/cutscene.tscn"))

		else:
			transition.change_scene(load("res://levels/3D Main Menu/3d_main_menu.tscn"))


func _ready():
	Music.play(MusicPlayer.Song.GeorgeStreetShuffle)
