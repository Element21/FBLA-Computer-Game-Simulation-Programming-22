extends HBoxContainer


func quit():
	get_tree().quit()


func documentation():
	# globalize_path doesn't work properly when exported
	assert(OK == OS.shell_open("https://raw.githubusercontent.com/Element21/FBLA-Computer-Game-Simulation-Programming-22/main/documentation/document.pdf"))
