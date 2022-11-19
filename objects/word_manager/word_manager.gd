extends Node

class_name WordManager


export var word_length = 5

var letters_placed = []

var platform_margin = 0.5

var letter_platform_scene = preload("res://objects/letter_platform/letter_platform.tscn")

func platform_index_to_x_position(index: int) -> float:
	
	return (word_length / 2 - index) * (1 + platform_margin)

func _ready():
	
	letters_placed.resize(word_length)
	
	for index in range(0, word_length):
		
		var platform = letter_platform_scene.instance()
		
		platform.translation.x = platform_index_to_x_position(index)
		
		add_child(platform)


func drop_letter(letter: Letter):
	
	var index = letters_placed.find(null)
	
	letters_placed[index] = letter


func next_platform_position():
	
	var index = letters_placed.find(null)
	
	return Vector2(self.global_translation.x, self.global_translation.z) + Vector2(platform_index_to_x_position(index), 0)
