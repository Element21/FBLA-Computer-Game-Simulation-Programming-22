extends Spatial

class_name Level


export var time_given = 30
export(PackedScene) var next_level
export(NodePath) onready var camera = get_node(camera) as Camera

onready var level_countdown = get_child(0) as LevelCountdown
onready var level_end_screen = get_child(1) as LevelEndScreen

onready var time_left = time_given
var score = 0
var playing = false

var letters_in_play = []


func put_letter_in_play(letter: Letter):
	letters_in_play.push_back(letter)


func remove_letter_from_play(letter: Letter):
	letters_in_play.remove(letters_in_play.find(letter))


func start():
	playing = true


func _ready():
	level_countdown.got_camera(camera)
	level_end_screen.next_level = next_level


func _process(delta):
	if playing:
		time_left -= delta
	
	if time_left < 0:
		letters_in_play.clear()
		playing = false
		
		level_end_screen.show()

