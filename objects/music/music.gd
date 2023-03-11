extends Node


var transition_duration = 2.0
var ambience_volume = 0.0
var gameplay_volume = -8.0


func start_ambience():
	var tween = get_tree().create_tween()
	tween.tween_property(%Sienexilin, "volume_db", ambience_volume, transition_duration).set_trans(Tween.TRANS_SINE)
	%Sienexilin.play()


func end_ambience():
	var tween = get_tree().create_tween()
	tween.tween_property(%Sienexilin, "volume_db", -80, transition_duration).set_trans(Tween.TRANS_SINE)
	tween.connect("finished", func(): %Sienexilin.stop())


func start_gameplay_music():
	var tween = get_tree().create_tween()
	tween.tween_property(%"My Song 6", "volume_db", gameplay_volume, transition_duration).set_trans(Tween.TRANS_SINE)
	%"My Song 6".play()


func end_gameplay_music():
	var tween = get_tree().create_tween()
	tween.tween_property(%"My Song 6", "volume_db", -80, transition_duration).set_trans(Tween.TRANS_SINE)
	tween.connect("finished", func(): %"My Song 6".stop())
