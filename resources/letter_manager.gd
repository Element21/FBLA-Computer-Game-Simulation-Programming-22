extends Node


var letters_in_play = []


func put_in_play(letter: Letter):
	
	letters_in_play.push_back(letter)


func remove_from_play(letter: Letter):
	
	letters_in_play.remove(letters_in_play.find(letter))


func reset_letters_in_play():
	
	letters_in_play.empty()
