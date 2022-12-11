extends Control


export(Array, PackedScene) var levels = []
export(Array, String) var level_names = []

export var level_button_distance = 20

export(NodePath) onready var level_buttons = get_node(level_buttons) as Control
export(NodePath) onready var level_data = get_node(level_data) as LevelData


func _ready():
	for i in range(0, level_names.size()):
		var button = Button.new()
		
		button.text = level_names[i]
		button.connect("button_down", level_data, "select_level", [i, level_names[i], levels[i]])
		
		level_buttons.add_child(button)
