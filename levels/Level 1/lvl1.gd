extends Node3D


@onready var tutorial: Tutorial = %Tutorial
@onready var level: Level = %Level

enum TutorialState {
	None,
	ClickLetters,
	DeleteLetter,
	TimeAlmostUp,
}

var state = TutorialState.None


func _level_started():
	tutorial.show_text("Click letters to spell words", Vector3(0, 17, 0), Vector2(0, tutorial.text_height()))
	state = TutorialState.ClickLetters
	
	await level.hand.grabbed_letter
	
	tutorial.hide_text()


var already_suggested_time_up = false

func _process(delta):
	if state != TutorialState.TimeAlmostUp && !already_suggested_time_up && level.time_left / level.time_given < 0.2:
		tutorial.show_text("Time's almost up!", level.word_manager.timer_pos(), Vector2(0, tutorial.text_height()))
		state = TutorialState.TimeAlmostUp
		already_suggested_time_up = true


func _grabbed_letter():
	if state == TutorialState.ClickLetters:
		tutorial.hide_text()
		state = TutorialState.None


var already_suggested_delete = false

func _bad_letter_placed(pos: Vector3):
	if already_suggested_delete:
		return
	
	tutorial.show_text("Click the platform to delete", pos, Vector2(0, tutorial.text_height()))
	already_suggested_delete = true
	state = TutorialState.DeleteLetter


func _deleted_letter():
	if state == TutorialState.DeleteLetter:
		tutorial.hide_text()
		state = TutorialState.None

