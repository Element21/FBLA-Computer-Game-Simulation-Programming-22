extends Control

signal first_play

var main_menu_scene: PackedScene = preload("res://Levels/Main Menu/main_menu.tscn")
var cutscene_scene: PackedScene = preload("res://Levels/Start Menu/Cutscene/cutscene.tscn")

export(NodePath) onready var name_input = get_node(name_input) as LineEdit

onready var empty_name_error = get_node("VBoxContainer/Empty name error")

func go_to_main_menu(_from_signal):
	if not LeaderboardManager.is_level_unlocked(2):
		"Assume this is first run, lauch cutscene"
		print("CUTSCENE")
		self.visible = false
		$Transition.visible = true
		$Transition/AnimationPlayer.play("fadeOut")
		var status = get_tree().change_scene_to(cutscene_scene)
		assert(status == OK)

	var name = name_input.text
	
	if name == "":
		empty_name_error.visible = true
	else:
		LeaderboardManager.set_player_name(name)
		
		var status = get_tree().change_scene_to(main_menu_scene)
		assert(status == OK)


func _ready():
	Music.start_ambience()
