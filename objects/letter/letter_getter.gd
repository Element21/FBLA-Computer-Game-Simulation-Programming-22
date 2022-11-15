extends Node


var letters_in_play = []
var letters_picked = []

# Recursively search the node tree for all the letters and push them to the list
func _push_letters(node: Node):
	
	if node is Letter:
		letters_in_play.push_back(node)
		return
	
	for child in node.get_children():
		_push_letters(child)


func _ready():
	
	_push_letters(get_tree().get_root())


func add_letter_to_picked(letter: Letter):
	
	letters_picked.push_back(letter)


func remove_from_play(letter: Letter):
	
	letters_in_play.remove(letters_in_play.find(letter))
