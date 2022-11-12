extends Node

class_name LetterForcefield

# Calculate what forces are being applied to the letter
func force_letter(letter: Letter) -> Vector3:
	
	return Vector3(0, 0, 0)

var letters = []

# Recursively search the node tree for all the letters and push them to the list
func push_letters(node: Node):
	
	if node is Letter:
		letters.push_back(node)
		return
	
	for child in node.get_children():
		push_letters(child)


func _ready():
	
	push_letters(get_tree().get_root())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for letter in letters:
		
		letter.apply_central_impulse(force_letter(letter) * delta)
