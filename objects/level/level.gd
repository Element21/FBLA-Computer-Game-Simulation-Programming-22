extends Spatial

class_name Level


export var time_given = 30
export(PackedScene) var next_level

onready var level_end_screen = get_child(0) as LevelEndScreen

onready var time_left = time_given
var score = 0
var playing = false

var letters_in_play = []


func put_letter_in_play(letter: Letter):
	
	letters_in_play.push_back(letter)


func remove_letter_from_play(letter: Letter):
	
	letters_in_play.remove(letters_in_play.find(letter))


func _ready():
	playing = true
	
	level_end_screen.next_level = next_level


func _process(delta):
	if playing:
		time_left -= delta
	
	if time_left < 0:
		letters_in_play.clear()
		playing = false
		
		level_end_screen.show()

