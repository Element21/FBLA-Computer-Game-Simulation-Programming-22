extends Node


func _input(event):
	if event.is_action_pressed("quit"):
		quit()


func quit():
	get_tree().quit()
