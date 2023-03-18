extends Control

signal first_play

var main_menu_scene: PackedScene = preload("res://Levels/Main Menu/main_menu.tscn")
var cutscene_scene: PackedScene = preload("res://Levels/Start Menu/Cutscene/cutscene.tscn")

@onready var transition: Transition = %Transition

func transition_finshed(anim_name):
	if anim_name == "fadeOut":
		self.visible = false
		var status = get_tree().change_scene_to_packed(cutscene_scene)
		assert(status == OK)

func go_to_main_menu(_from_signal):
	var name_given = (%"Name input" as LineEdit).text
	
	if name_given == "":
		(%"Empty name error" as Label).visible = true
	else:
		LeaderboardManager.set_player_name(name_given)
		if not LeaderboardManager.is_level_unlocked(1):
			"Assume this is first run, lauch cutscene"
			transition.visible = true
			transition.animation_player.play("fadeOut")

		else:
			var status = get_tree().change_scene_to_packed(main_menu_scene)
			assert(status == OK)


func _ready():
	assert(OK == transition.animation_player.connect("animation_finished", transition_finshed))
	Music.start_ambience()
