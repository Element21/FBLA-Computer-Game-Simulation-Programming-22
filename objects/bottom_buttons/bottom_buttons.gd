extends HBoxContainer


func quit():
	get_tree().quit()


func documentation():
	OS.shell_open(ProjectSettings.globalize_path("res://documentation/document.pdf"))
