extends Node

# https://github.com/dwyl/english-words
# 2D array, first index is word length minus 1, second is the index of the word; this helps with optimization
onready var words: Array = load_words()


func load_words() -> Array:
	
	var f = File.new()
	f.open("res://objects/words.txt", File.READ)
	
	var new_words = []
	
	for _i in range(0, 31):
		new_words.push_back([])
	
	while not f.eof_reached():
		var word = f.get_line()

		new_words[word.length() - 1].push_back(word)
	
	f.close()
	
	return new_words


func is_word(letters: Array) -> bool:
	
	for word in words[letters.size() - 1]:
		if compare_word(word, letters):
			return true
	
	return false


func letters_that_could_be_used(letters: Array) -> int:
	
	var empty_index = letters.find(null)
	
	var could_be_placed = []
	
	could_be_placed.resize(26)
	could_be_placed.fill(false)
	
	for word in words[letters.size() - 1]:
		if compare_word(word, letters):
			could_be_placed[word.ord_at(empty_index) - 97] = true
	
	return could_be_placed.count(true)


# Assumes word & letters are the same length
func compare_word(word: String, letters: Array) -> bool:
		
	for i in range(0, word.length()):
		if letters[i] == null:
			continue
		
		if word[i] != letters[i].which_letter:
			return false
	
	return true
