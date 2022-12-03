extends Spatial

class_name Level


export var time_given = 30

onready var time_left = time_given
var score = 0
var playing = false

var letters_in_play = []


signal level_end


func put_letter_in_play(letter: Letter):
	
	letters_in_play.push_back(letter)


func remove_letter_from_play(letter: Letter):
	
	letters_in_play.remove(letters_in_play.find(letter))


func _ready():
	playing = true


func _process(delta):
	if playing:
		time_left -= delta
	
	if time_left < 0:
		letters_in_play.clear()
		playing = false
		
		emit_signal("level_end")

