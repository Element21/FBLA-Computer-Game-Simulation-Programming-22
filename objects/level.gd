extends Spatial

class_name Level


export var time_given = 30


onready var time_left = time_given
var score = 0

var letters_in_play = []


func put_letter_in_play(letter: Letter):
	
	letters_in_play.push_back(letter)


func remove_letter_from_play(letter: Letter):
	
	letters_in_play.remove(letters_in_play.find(letter))


func _process(delta):
	time_left -= delta
