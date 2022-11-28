extends Node

class_name WordManager


export var word_length = 5
export var time_given = 30
export(NodePath) onready var camera = get_node(camera) as Camera

var score = 0
onready var time_left = time_given

onready var launch_word_timer: Timer = get_child(0)
onready var platforms: Spatial = get_child(1)
onready var ui: Spatial = get_child(2)
onready var score_mesh: MeshInstance = ui.get_child(0)
onready var time_indicator: Spatial = ui.get_child(1).get_child(0)

var letters_placed = []

var platform_margin = 0.5

var letter_platform_scene = preload("res://objects/letter_platform/letter_platform.tscn")

func platform_index_to_x_position(index: int) -> float:
	
	return (index - word_length / 2) * (1 + platform_margin)


func _ready():
	
	letters_placed.resize(word_length)
	
	for index in range(0, word_length):
		var platform = letter_platform_scene.instance()
		
		platform.translation.x = platform_index_to_x_position(index)
		
		platforms.add_child(platform)
	
	var camera_displacement_from_ui = camera.global_translation - ui.global_translation
	
	ui.rotation.x = atan2(camera_displacement_from_ui.y, camera_displacement_from_ui.z)


func _process(delta):
	
	time_left -= delta
	
	time_indicator.scale.x = time_left / time_given
	
	if time_left < 0:
		print("DONE")


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
	
	for platform in platforms.get_children():
		score += platform.score
	
	score_mesh.mesh.text = String(score)
	
	letters_placed.fill(null)
	
	launch_word_timer.start()


func launch_all_platforms():
	for child in platforms.get_children():
		child.launch()


func next_platform_position():
	
	var index = letters_placed.find(null)
	
	return Vector2(self.global_translation.x, self.global_translation.z) + Vector2(platform_index_to_x_position(index), 0)


func _input(event):
	if event.is_action_pressed("delete_letter"):
		delete()


func delete():
	
	var last_letter_index = null
		
	for i in range(0, letters_placed.size()):
		if letters_placed[i] != null:
			last_letter_index = i
	
	if last_letter_index != null:
		
		letters_placed[last_letter_index] = null
		
		platforms.get_child(last_letter_index).flip()
