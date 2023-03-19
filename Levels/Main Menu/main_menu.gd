extends Control


@export var levels = [] # (Array, PackedScene)
@export var level_names = [] # (Array, String)

@export var level_button_distance = 20

@onready var instructions: PopupPanel = %Instructions


func _ready():
	# Prevent it from opening automatically
	instructions.hide()
	
	# Add buttons for each level
	for i in range(0, level_names.size()):
		var button = Button.new()
		
		button.text = level_names[i]
		var err = button.connect("button_down", func(): (%"Level data" as LevelData).select_level(i, levels[i]))
		assert(err == OK)
		
		button.disabled = !LeaderboardManager.is_level_unlocked(i)
		
		(%"Level buttons" as BoxContainer).add_child(button)
	
	
	if !LeaderboardManager.is_level_unlocked(1):
		# The popup will close instantly if I don't do these awaits, idk why
		await get_tree().process_frame
		await get_tree().process_frame
		instructions.popup_centered_clamped()

