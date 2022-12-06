extends Node


var transition_duration = 2.0
var ambience_volume = -4.0
var gameplay_volume = -12.0


onready var sienexilin: AudioStreamPlayer = get_node("Sienexilin")
onready var my_song_6: AudioStreamPlayer = get_node("My Song 6")
onready var fade_in: Tween = get_node("Fade in")
onready var fade_out: Tween = get_node("Fade out")


func start_ambience():
	fade_in.interpolate_property(sienexilin, "volume_db", -80, ambience_volume, transition_duration, Tween.TRANS_SINE)
	fade_in.start()
	sienexilin.play()


func end_ambience():
	fade_out.interpolate_property(sienexilin, "volume_db", ambience_volume, -80, transition_duration, Tween.TRANS_SINE)
	fade_out.start()


func start_gameplay_music():
	fade_in.interpolate_property(my_song_6, "volume_db", -80, gameplay_volume, transition_duration, Tween.TRANS_SINE)
	fade_in.start()
	my_song_6.play()


func end_gameplay_music():
	fade_out.interpolate_property(my_song_6, "volume_db", gameplay_volume, -80, transition_duration, Tween.TRANS_SINE)
	fade_out.start()


func done_fading_out(object: Object, key: NodePath):
	object.stop()
