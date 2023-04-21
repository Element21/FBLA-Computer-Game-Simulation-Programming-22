extends Camera3D

class_name GameCamera


@onready var transition: Transition = %Transition

func hide_reset():
	%Reset.hide()
