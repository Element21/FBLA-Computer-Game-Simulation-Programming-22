extends Node3D

class_name Level


@export var time_given = 30.
@export var countdown = true
@export var enable_timer = true
@export var level_index: int
@export var camera: Camera3D
@export var song: MusicPlayer.Song

@onready var hand: Hand = Utils.search(self.get_children(), func(c): return c is Hand)
@onready var word_manager: WordManager = Utils.search(self.get_children(), func(c): return c is WordManager)

@onready var transition: Transition = Utils.search(camera.get_children(), func(c): return c is Transition)
@onready var time_left = time_given
var score = 0
var playing = false

@onready var level_end_screen: LevelEndScreen = %"Level end screen"

signal level_ended

func start():
	playing = true


func _ready():
	randomize()
	Music.play(song)
	if countdown:
		(%"Level countdown" as LevelCountdown).start(camera)
	else:
		start()
	
	assert(transition != null)
	
	level_end_screen.level_index = level_index
	level_end_screen.transition = transition


func _process(delta):
	if playing && enable_timer:
		time_left -= delta
	
	if time_left < 0 && playing:
		level_ended.emit()
		playing = false
		
		LeaderboardManager.add_score(level_index, score)
		
		Music.play(MusicPlayer.Song.Cooking)
		
		level_end_screen.level_ended(score)

