extends Node2D

onready var slideNode = $Slide
onready var transitionNode = $Transition

var slide_counter = 0

var slideList = ["slide_1", "slide_2", "slide_3", "slide_4", "slide_5", "slide_6", "slide_7", "slide_8", "slide_9"]

func fadeIn():
	$ColorRect/AnimationPlayer.play("fadeIn")

func fadeOut():
	$ColorRect/AnimationPlayer.play("fadeOut")

func _start_menu_node_on_first_play():
	slideNode.texture = "res://resources/cutscene_frames/" + slideList[slide_counter] + ".png"
	self.hidden = false
	fadeIn()

func _ready():
	self.hidden = true
	transitionNode.start_menu_node_passthough.connect("first_play", self, "_start_menu_node_on_first_play")
	slideNode.connect("gui_input", self, "_slide_on_gui_input")
