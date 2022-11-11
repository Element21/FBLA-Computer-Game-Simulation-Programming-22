extends MeshInstance

export var height: float = 0
export var buoyancy_acceleration = 9.81 * 2
export var drag = 2

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


func buoyancy(letter_height: float):
	var depth = height - letter_height
	
	if depth < -0.1:
		return 0
	elif depth < 0.1:
		return buoyancy_acceleration * inverse_lerp(-0.1, 0.1, depth)
	else:
		return buoyancy_acceleration

func _process(delta):
	
	for letter in letters:
		var pos = letter.translation
		
		# Check if the letter is below the soup, then check if it's in the soup
		if pos.y < height + 0.1: #&& Geometry.is_point_in_polygon(Vector2(pos.x, pos.z), points):
			var acceleration = buoyancy(pos.y)
			
			# Buoyancy
			letter.apply_central_impulse(Vector3(0, acceleration, 0) * delta * letter.mass)
			
			# Drag
			letter.apply_central_impulse(letter.linear_velocity * drag * delta * -1)
	
	pass
