extends Node


@onready var level_scenes = [
	preload("res://Levels/Level 1/lvl1.tscn"),
	preload("res://Levels/Level 2/lvl2.tscn"),
	preload("res://Levels/Level 3/lvl3.tscn"),
	preload("res://Levels/Level 4/lvl4.tscn"),
	preload("res://Levels/Level 5/lvl5.tscn"),
]

func get_by_index(idx: int) -> PackedScene:
	return level_scenes[idx]
