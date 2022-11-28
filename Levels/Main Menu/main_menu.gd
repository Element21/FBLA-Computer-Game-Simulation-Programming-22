extends Control


export(Array, PackedScene) var levels = []
export(Array, String) var level_names = []

export(Vector2) var level_button_size
export var level_button_distance = 20

onready var level_buttons: Control = get_child(0)
onready var level_data: LevelData = get_child(1)


func _ready():
	
	for i in range(0, level_names.size()):
		var button = Button.new()
		
		button.text = level_names[i]
		button.rect_position.y = i * level_button_distance
		button.rect_size = level_button_size
		
		button.connect("button_down", level_data, "select_level", [i, level_names[i], levels[i]])
		
		level_buttons.add_child(button)
