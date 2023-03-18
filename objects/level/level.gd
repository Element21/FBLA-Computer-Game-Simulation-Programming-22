extends Node3D

class_name Level


@export var time_given = 30.
@export var countdown = true
@export var enable_timer = true
@export var next_level: PackedScene
@export var level_index: int
@export var camera: Camera3D


@onready var time_left = time_given
var score = 0
var playing = false

@onready var level_end_screen: LevelEndScreen = %"Level end screen"

signal level_ended

func start():
	playing = true
	Music.start_gameplay_music()


func _ready():
	randomize()
	if countdown:
		(%"Level countdown" as LevelCountdown).start(camera)
	else:
		start()
	
	level_end_screen.next_level = next_level
	level_end_screen.level_index = level_index


func _process(delta):
	if playing && enable_timer:
		time_left -= delta
	
	if time_left < 0 && playing:
		assert(OK == emit_signal("level_ended"))
		playing = false
		
		LeaderboardManager.add_score(level_index, score)
		
		Music.end_gameplay_music()
		
		level_end_screen.level_ended(score)

