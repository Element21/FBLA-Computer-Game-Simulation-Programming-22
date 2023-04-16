extends Node

class_name MusicPlayer


var transition_duration = 2.0


enum Song {
	None = -1,
	Sienexilin = 0,
	LocalForecast = 1,
	MySong6 = 2,
	Cooking = 3,
	GeorgeStreetShuffle = 4,
}

var playing: Song = Song.None


@onready var songs: Array[AudioStreamPlayer] = [
	%Sienexilin as AudioStreamPlayer,
	%"Local Forecast" as AudioStreamPlayer,
	%"My Song 6" as AudioStreamPlayer,
	%Cooking as AudioStreamPlayer,
	%"George Street Shuffle" as AudioStreamPlayer,
]

@onready var volumes: PackedFloat64Array = PackedFloat64Array(songs.map(func(v): return v.volume_db))


func _ready():
	for song in songs:
		song.volume_db = -80


func play(song: Song):
	if song == playing:
		return
	
	if song != Song.None:
		var tween = get_tree().create_tween()
		
		@warning_ignore("return_value_discarded")
		tween.tween_property(songs[song], "volume_db", volumes[song], transition_duration).set_trans(Tween.TRANS_SINE)
		songs[song].play()
	
	if playing != Song.None:
		_stop()
	
	playing = song


func _stop():
	var tween = get_tree().create_tween()
	
	var player = songs[playing]
	@warning_ignore("return_value_discarded")
	tween.tween_property(player, "volume_db", -80, transition_duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
	player.stop()
