extends HBoxContainer


func quit():
	Quitter.quit()


func documentation():
	print(ProjectSettings.globalize_path("res://documentation/document.pdf"))
	OS.shell_open(ProjectSettings.globalize_path("res://documentation/document.pdf"))
