extends Control


var main_menu_scene: PackedScene = preload("res://Levels/Main Menu/main_menu.tscn")

export(NodePath) onready var name_input = get_node(name_input) as LineEdit


func go_to_main_menu(_from_signal):
	var status = get_tree().change_scene_to(main_menu_scene)
	assert(status == OK)
	
	LeaderboardManager.set_player_name(name_input.text)
