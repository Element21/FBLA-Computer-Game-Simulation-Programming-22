extends Node3D


@onready var tutorial: Tutorial = %Tutorial
@onready var level: Level = %Level


func _level_started():
	tutorial.show_text("Harder words score more points", level.word_manager.global_position + Vector3(0, 0, -1), Vector2(0, tutorial.text_height() + 8))
	
	await level.word_manager.made_word
	
	tutorial.hide_text()
