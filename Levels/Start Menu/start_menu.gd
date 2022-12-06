extends Control


var main_menu_scene: PackedScene = preload("res://Levels/Main Menu/main_menu.tscn")

export(NodePath) onready var name_input = get_node(name_input) as LineEdit

onready var empty_name_error = get_node("VBoxContainer/Empty name error")


func go_to_main_menu(_from_signal):
	var name = name_input.text
	
	if name == "":
		empty_name_error.visible_characters = -1
	else:
		LeaderboardManager.set_player_name(name)
		
		var status = get_tree().change_scene_to(main_menu_scene)
		assert(status == OK)


func quit():
	Quitter.quit()


func _ready():
	Music.start_ambience()
