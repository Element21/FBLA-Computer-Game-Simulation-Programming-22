extends Spatial

class_name Level


export var time_given = 30
export var countdown = true
export var enable_timer = true
export(PackedScene) var next_level
export(int) var level_index
export(NodePath) onready var camera = get_node(camera) as Camera

onready var level_countdown = get_child(0) as LevelCountdown
onready var level_end_screen = get_child(1) as LevelEndScreen

onready var time_left = time_given
var score = 0
var playing = false

signal level_ended

func start():
	playing = true
	Music.start_gameplay_music()


func _ready():
	randomize()
	if countdown:
		level_countdown.start(camera)
	else:
		start()
	
	level_end_screen.next_level = next_level
	level_end_screen.level_index = level_index


func _process(delta):
	if playing && enable_timer:
		time_left -= delta
	
	if time_left < 0 && playing:
		emit_signal("level_ended")
		playing = false
		
		LeaderboardManager.add_score(level_index, score)
		
		Music.end_gameplay_music()
		
		level_end_screen.level_ended(score)

