extends Node


@onready var level_scenes = [
	load("res://levels/Level 1/lvl1.tscn"),
	load("res://levels/Level 2/lvl2.tscn"),
	load("res://levels/Level 3/lvl3.tscn"),
	load("res://levels/Level 4/lvl4.tscn"),
	load("res://levels/Level 5/lvl5.tscn"),
]

func get_by_index(idx: int):
	if idx >= level_scenes.size():
		return null
	
	return level_scenes[idx]
