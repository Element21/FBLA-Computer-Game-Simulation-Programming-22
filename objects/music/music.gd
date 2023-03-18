extends Node


var transition_duration = 2.0
var ambience_volume = 0.0
var gameplay_volume = -8.0

@onready var sienexilin: AudioStreamPlayer = %Sienexilin
@onready var my_song_6: AudioStreamPlayer = %"My Song 6"


func start_ambience():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_property(sienexilin, "volume_db", ambience_volume, transition_duration).set_trans(Tween.TRANS_SINE)
	sienexilin.play()


func end_ambience():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_property(sienexilin, "volume_db", -80, transition_duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
	sienexilin.stop()


func start_gameplay_music():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_property(my_song_6, "volume_db", gameplay_volume, transition_duration).set_trans(Tween.TRANS_SINE)
	my_song_6.play()


func end_gameplay_music():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_property(my_song_6, "volume_db", -80, transition_duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
	my_song_6.stop()
