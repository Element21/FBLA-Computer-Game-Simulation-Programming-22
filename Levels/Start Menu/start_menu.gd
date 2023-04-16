extends Control

signal first_play

var main_menu_scene: PackedScene = preload("res://Levels/3D Main Menu/3d_main_menu.tscn")
var cutscene_scene: PackedScene = preload("res://Levels/Start Menu/Cutscene/cutscene.tscn")

@onready var transition: Transition = %Transition


func go_to_main_menu(_from_signal):
	var name_given = (%"Name input" as LineEdit).text
	
	if name_given == "":
		(%"Empty name error" as Label).visible = true
	else:
		LeaderboardManager.set_player_name(name_given)
		if not LeaderboardManager.is_level_unlocked(1):
			# Assume this is first run, lauch cutscene
			transition.change_scene(cutscene_scene)

		else:
			transition.change_scene(main_menu_scene)


func _ready():
	Music.play(MusicPlayer.Song.GeorgeStreetShuffle)
