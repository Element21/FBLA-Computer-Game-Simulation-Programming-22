extends Node

# https://github.com/dwyl/english-words
# 2D array, first index is word length minus 1, second is the index of the word; this helps with optimization
@onready var words: Array = load_words()


# Create the words array from the list
func load_words() -> Array:
	var f = FileAccess.open("res://objects/words.txt", FileAccess.READ)
	
	var new_words = []
	
	# The longest word is 31 letters
	for _i in range(0, 31):
		new_words.push_back([])
	
	while not f.eof_reached():
		var word = f.get_line()

		(new_words[word.length() - 1] as Array[String]).push_back(word)
	
	f.close()
	
	return new_words


func matches_word(letters: Array[Letter]) -> bool:
	# Check all the words of the same length to make sure the word is valid
	for word in words[letters.size() - 1]:
		if compare_word(word, letters):
			return true
	
	return false


func calculate_score_added(letters: Array[Letter]):
	var amt_could_be_placed = letters_that_could_be_used_next(letters)
	
	if amt_could_be_placed == 0:
		return null
	
	return 27 - amt_could_be_placed


func letters_that_could_be_used_next(letters: Array[Letter]) -> int:
	var empty_index = letters.find(null)
	
	var could_be_placed = []
	
	@warning_ignore("return_value_discarded")
	could_be_placed.resize(26)
	could_be_placed.fill(false)
	
	for word in words[letters.size() - 1] as Array[String]:
		if compare_word(word, letters):
			could_be_placed[word.unicode_at(empty_index) - 97] = true
	
	return could_be_placed.count(true)


# Assumes word & letters are the same length
func compare_word(word: String, letters: Array[Letter]) -> bool:
	for i in range(0, word.length()):
		if letters[i] == null:
			continue
		
		if word[i] != letters[i].which_letter:
			return false
	
	return true
