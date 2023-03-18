extends ColorRect

class_name Transition

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready():
	self.custom_minimum_size = get_window().size
 
