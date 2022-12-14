extends TextureRect

signal next_slide

func _gui_input(event):
	emit_signal("next_slide", event)
