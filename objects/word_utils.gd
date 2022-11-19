extends Node

# https://github.com/dwyl/english-words
onready var words: PoolStringArray = load_words()


func load_words() -> PoolStringArray:
	
	var f = File.new()
	f.open("res://objects/words.txt", File.READ)
	
	var new_words = []
	
	while not f.eof_reached():
		new_words.push_back(f.get_line())
	
	f.close()
	
	return new_words


func fraction_of_words_unavailable(letters: Array) -> float:
	
	var options = 0
	
	for word in words:
		
		if compare_word(word, letters):
			options += 1
	
	return options / words.size()


func compare_word(word: String, letters: Array) -> bool:
	
	if word.length() != letters.size():
		return false
		
	for i in range(0, word.length()):
		if letters[i] == null:
			continue
		
		if word[i] != letters[i]:
			return false
	
	return true
