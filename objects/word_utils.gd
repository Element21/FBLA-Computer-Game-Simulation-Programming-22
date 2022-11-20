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


func fraction_of_words_unavailable(letters: Array) -> float:
	
	var options = 0.0
	
	for word in words[letters.size() - 1]:
		if compare_word(word, letters):
			options += 1
	
	return options / words.size()


# Assumes word & letters are the same length
func compare_word(word: String, letters: Array) -> bool:
		
	for i in range(0, word.length()):
		if letters[i] == null:
			continue
		
		if word[i] != letters[i].which_letter:
			return false
	
	return true
