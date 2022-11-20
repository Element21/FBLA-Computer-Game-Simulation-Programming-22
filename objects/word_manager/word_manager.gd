extends Node

class_name WordManager


export var word_length = 5

onready var make_word_timer: Timer = get_child(0)
onready var platforms: Spatial = get_child(1)

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
		
		platforms.add_child(platform)


func place_letter(letter: Letter):
	
	var index = letters_placed.find(null)
	
	letters_placed[index] = letter
	
	if letters_placed.find(null) == -1:
		
		# I implemented it like this so we can reuse this function to calculate score in the future
		if WordUtils.fraction_of_words_unavailable(letters_placed) != 0:
			word_made()


func word_made():
	
	letters_placed.fill(null)
	
	make_word_timer.start()


func flip_all_platforms():
	for child in platforms.get_children():
		child.flip()


func next_platform_position():
	
	var index = letters_placed.find(null)
	
	return Vector2(self.global_translation.x, self.global_translation.z) + Vector2(platform_index_to_x_position(index), 0)


func _input(event):
	if event.is_action_pressed("delete_letter"):
		delete()


func delete():
	
	var last_letter_index = null
		
	for i in range(0, letters_placed.size()):
		if letters_placed[i] != null:
			last_letter_index = i
	
	if last_letter_index != null:
		
		letters_placed[last_letter_index] = null
		
		platforms.get_child(last_letter_index).flip()
