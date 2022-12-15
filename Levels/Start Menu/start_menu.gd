extends Control

signal first_play

var main_menu_scene: PackedScene = preload("res://Levels/Main Menu/main_menu.tscn")
var cutscene_scene: PackedScene = preload("res://Levels/Start Menu/Cutscene/cutscene.tscn")

export(NodePath) onready var name_input = get_node(name_input) as LineEdit

onready var empty_name_error = get_node("VBoxContainer/Empty name error")

func _on_animationPlayer_animation_finshed(anim_name):
	if anim_name == "fadeOut":
		self.visible = false
		var status = get_tree().change_scene_to(cutscene_scene)
		assert(status == OK)

func go_to_main_menu(_from_signal):
	var name = name_input.text
	
	if name == "":
		empty_name_error.visible = true
	else:
		LeaderboardManager.set_player_name(name)
		if not LeaderboardManager.is_level_unlocked(1):
			"Assume this is first run, lauch cutscene"
			$Transition.visible = true
			$Transition/AnimationPlayer.play("fadeOut")

		else:
			var status = get_tree().change_scene_to(main_menu_scene)
			assert(status == OK)


func _ready():
	$Transition/AnimationPlayer.connect("animation_finished", self, "_on_animationPlayer_animation_finshed")
	Music.start_ambience()
