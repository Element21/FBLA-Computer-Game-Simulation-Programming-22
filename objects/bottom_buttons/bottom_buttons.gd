extends HBoxContainer


func quit():
	Quitter.quit()


func documentation():
	OS.shell_open(ProjectSettings.globalize_path("res://documentation/document.pdf"))