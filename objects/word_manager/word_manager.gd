extends Node

class_name WordManager


@export var word_length = 5
@export var launch_vector: Vector3 = Vector3(0, 2, 5)
@onready var level: Level = self.get_parent()

var letters_placed = []

var platform_margin = 0.5

var letter_platform_scene = preload("res://objects/letter_platform/letter_platform.tscn")

@onready var platforms: Node3D = %Platforms
@onready var ui: Node3D = %UI
@onready var score_mesh: MeshInstance3D = %"Score mesh"


# Get the local x position of a given platform
func platform_index_to_x_position(index: int) -> float:
	return (index - word_length / 2.) * (1 + platform_margin)


func _ready():
	@warning_ignore("return_value_discarded")
	letters_placed.resize(word_length)
	
	(score_mesh.mesh as TextMesh).text = "0"
	
	# Instantiate all the platforms
	for index in range(0, word_length):
		var platform = letter_platform_scene.instantiate()
		
		platform.launch_vector = launch_vector
		platform.position.x = platform_index_to_x_position(index)
		
		platforms.add_child(platform)
	
	# Point the score counter & timer at the camera
	var camera_displacement_from_ui = level.camera.global_position - ui.global_position
	
	ui.rotation.x = atan2(camera_displacement_from_ui.z, camera_displacement_from_ui.y)


func _process(_delta):
	# Making it go fast at the beginning makes the beginning more exciting because the timer is going fast, and more exciting at the end because it looks like you don't have much time left (and makes succeeding anyways that much better)
	# This is a common trick with health bars
	(%"Time indicator" as Node3D).scale.x = 1 - Tweening.fast_then_slow(1 - level.time_left / level.time_given)


# Called when the hand drops a letter, tells the platform that a letter was dropped on it, validates the letter sequence, and calculates score
func place_letter(letter: Letter):
	var index = letters_placed.find(null)
	
	var platform: LetterPlatform = platforms.get_child(index)
	
	var matches_before = WordUtils.matches_word(letters_placed)
	
	if matches_before:
		platform.set_score(WordUtils.calculate_score_added(letters_placed))
	
	letters_placed[index] = letter
	platform.letter = letter
	
	var matches_after = WordUtils.matches_word(letters_placed)
	
	if !matches_after:
		platform.set_score(null)
	
	if letters_placed.find(null) == -1 && matches_after:
		word_made()


func word_made():
	for platform in platforms.get_children() as Array[LetterPlatform]:
		level.score += platform.score
	
	(score_mesh.mesh as TextMesh).text = String.num_int64(level.score)
	
	letters_placed.fill(null)
	
	await get_tree().create_timer(1.).timeout
	launch_all_platforms()


func no_spots_left() -> bool:
	return letters_placed.find(null) == -1


func launch_all_platforms():
	for child in platforms.get_children() as Array[LetterPlatform]:
		child.launch()


# Get the position of the next empty platform
func next_platform_position() -> Vector3:
	var index = letters_placed.find(null)
	
	var platform: LetterPlatform = platforms.get_child(index)
	
	return platform.global_position


func _input(event: InputEvent):
	if level.playing && event.is_action_pressed("delete_letter"):
		delete()


# Delete a letter
func delete():
	var last_letter_index = null
		
	for i in range(0, letters_placed.size()):
		if letters_placed[i] != null:
			last_letter_index = i
	
	if last_letter_index != null:
		
		letters_placed[last_letter_index] = null
		
		(platforms.get_child(last_letter_index) as LetterPlatform).flip()
	
	level.hand.letter_deleted()
