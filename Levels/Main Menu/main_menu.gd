extends Control


export(Array, PackedScene) var levels = []
export(Array, String) var level_names = []

export(Vector2) var level_button_size
export var level_button_distance = 20

export(NodePath) onready var level_buttons = get_node(level_buttons) as Control
export(NodePath) onready var level_data = get_node(level_data) as LevelData


func _ready():
	for i in range(0, level_names.size()):
		var button = Button.new()
		var spacer = Control.new()
		
		button.text = level_names[i]
		button.rect_min_size = level_button_size
		
		spacer.rect_min_size.y = level_button_distance
		
		button.connect("button_down", level_data, "select_level", [i, level_names[i], levels[i]])
		
		level_buttons.add_child(button)
		level_buttons.add_child(spacer)
