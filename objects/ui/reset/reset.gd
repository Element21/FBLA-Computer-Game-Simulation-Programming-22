extends Control

class_name Reset


@export var transition: Transition
@onready var label: Label = %Label
@onready var button: Button = %Button

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "Playing as: " + LeaderboardManager.player_name
	


func _on_reset():
	transition.change_scene(load("res://levels/Start Menu/start_menu.tscn"))
