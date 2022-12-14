extends Control

onready var slideNode = $Slide

var slide_counter = 0

var slideList = ["slide_1", "slide_2", "slide_3", "slide_4", "slide_5", "slide_6", "slide_7", "slide_8", "slide_9"]

var main_menu_scene: PackedScene = preload("res://Levels/Main Menu/main_menu.tscn")

func fadeIn():
	$Transition/AnimationPlayer.play("fadeIn")

func fadeOut():
	$Transition/AnimationPlayer.play("fadeOut")

func _slide_on_gui_input():
	if slide_counter == 8:
		get_tree().change_scene_to(main_menu_scene)
	slide_counter += 1
	fadeOut()
	slideNode.set_texture(load("res://resources/cutscene_frames/" + slideList[slide_counter] + ".png"))
	fadeIn()

func _ready():
	slideNode.set_texture(load("res://resources/cutscene_frames/" + slideList[slide_counter] + ".png"))
	fadeIn()
	self.visible = true
	slideNode.connect("gui_input", self, "_slide_on_gui_input")
