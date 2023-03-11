extends Control


@export var levels = [] # (Array, PackedScene)
@export var level_names = [] # (Array, String)

@export var level_button_distance = 20


func _ready():
	if !LeaderboardManager.is_level_unlocked(1):
		%Instructions.popup()
	
	# Add buttons for each level
	for i in range(0, level_names.size()):
		var button = Button.new()
		
		button.text = level_names[i]
		button.connect("button_down", func(): %"Level data".select_level(i, level_names[i], levels[i]))
		
		button.disabled = !LeaderboardManager.is_level_unlocked(i)
		
		%"Level buttons".add_child(button)
