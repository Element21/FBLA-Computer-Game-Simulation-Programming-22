extends ColorRect

@onready var animation_player = %AnimationPlayer

func _ready():
	self.custom_minimum_size = get_window().size
 
