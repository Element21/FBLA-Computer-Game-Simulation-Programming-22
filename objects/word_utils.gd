extends Node

# 2D array, first index is word length minus 1, second is the letter's number (a=0, z=25)
var letter_distributions: Array[Array] = []

# https://github.com/dwyl/english-words
# 2D array, first index is word length minus 1, second is the index of the word; this helps with optimization
@onready var words: Array[PackedStringArray] = load_words()


# Create the words array from the list
func load_words() -> Array[PackedStringArray]:
	randomize()
	
	var f = FileAccess.open("res://objects/words.txt", FileAccess.READ)
	
	var new_words: Array[PackedStringArray] = []
	var letter_counts: Array[Array] = []
	var letter_totals: Array[int] = []
	
	# Don't bother processing words too long, the game will probably never use them (the longest word is 31 letters)
	@warning_ignore("return_value_discarded")
	letter_distributions.resize(10)
	for _i in range(0, 10):
		new_words.push_back(PackedStringArray())
		
		letter_totals.push_back(0)
		
		var letter_amt_array = []
		@warning_ignore("return_value_discarded")
		letter_amt_array.resize(26)
		letter_amt_array.fill(0)
		letter_counts.push_back(letter_amt_array)
	
	while not f.eof_reached():
		var word: String = f.get_line()
		
		var len_idx = word.length() - 1
		
		if new_words.size() <= len_idx:
			continue

		@warning_ignore("return_value_discarded")
		new_words[len_idx].push_back(word)
		
		for letter in word:
			letter_counts[len_idx][letter.unicode_at(0) - 97] += 1
			letter_totals[len_idx] += 1
	
	f.close()
	
	for i in range(0, letter_distributions.size()):
		letter_distributions[i] = letter_counts[i].map(func(v): return v as float / letter_totals[i] as float)
	
	return new_words

var alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

func random_letter(word_len: int) -> String:
	var num = randf()
	var count = 0.
	
	var distribution = letter_distributions[word_len - 1]
	
	for i in range(0, distribution.size()):
		count += distribution[i]
		
		if num <= count:
			return alphabet[i]
	
	return 'z'

var letter_meshes: Array[ArrayMesh] = [
	preload("res://resources/letters/a.obj"),
	preload("res://resources/letters/b.obj"),
	preload("res://resources/letters/c.obj"),
	preload("res://resources/letters/d.obj"),
	preload("res://resources/letters/e.obj"),
	preload("res://resources/letters/f.obj"),
	preload("res://resources/letters/g.obj"),
	preload("res://resources/letters/h.obj"),
	preload("res://resources/letters/i.obj"),
	preload("res://resources/letters/j.obj"),
	preload("res://resources/letters/k.obj"),
	preload("res://resources/letters/l.obj"),
	preload("res://resources/letters/m.obj"),
	preload("res://resources/letters/n.obj"),
	preload("res://resources/letters/o.obj"),
	preload("res://resources/letters/p.obj"),
	preload("res://resources/letters/q.obj"),
	preload("res://resources/letters/r.obj"),
	preload("res://resources/letters/s.obj"),
	preload("res://resources/letters/t.obj"),
	preload("res://resources/letters/u.obj"),
	preload("res://resources/letters/v.obj"),
	preload("res://resources/letters/w.obj"),
	preload("res://resources/letters/x.obj"),
	preload("res://resources/letters/y.obj"),
	preload("res://resources/letters/z.obj"),
]

func mesh_of(letter: String) -> ArrayMesh:
	return letter_meshes[letter.unicode_at(0) - 97]

@onready var inverse_mesh_translations: PackedVector3Array = PackedVector3Array(letter_meshes.map(inverse_mesh_translation))

func inverse_translation_of(letter: String) -> Vector3:
	return inverse_mesh_translations[letter.unicode_at(0) - 97]

# Daniel's letter models are offset, this undoes the position
# This assumes that the vertices are about evenly spread out, otherwise the average will be biased towards where there's a higher density of vertices
func inverse_mesh_translation(new_mesh: ArrayMesh) -> Vector3:
	var avg_translation = Vector3(0, 0, 0)
	
	var mesh_data_tool = MeshDataTool.new()
	assert(OK == mesh_data_tool.create_from_surface(new_mesh, 0))
	
	var vertex_count = mesh_data_tool.get_vertex_count()
	var inverse_vertex_count = 1.0 / vertex_count
	
	for i in range(vertex_count):
		var vertex = mesh_data_tool.get_vertex(i)
		
		avg_translation += vertex * inverse_vertex_count
	
	return -avg_translation

func matches_word(letters: Array) -> bool:
	# Check all the words of the same length to make sure the word is valid
	for word in words[letters.size() - 1]:
		if compare_word(word, letters):
			return true
	
	return false


func calculate_score_added(letters: Array):
	var amt_could_be_placed = letters_that_could_be_used_next(letters)
	
	if amt_could_be_placed == 0:
		return null
	
	return 27 - amt_could_be_placed


func letters_that_could_be_used_next(letters: Array) -> int:
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
func compare_word(word: String, letters: Array) -> bool:
	for i in range(0, word.length()):
		if letters[i] == null:
			continue
		
		if word[i] != letters[i].which_letter:
			return false
	
	return true
