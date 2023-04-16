extends Control

var slide_counter = 0

var slideList = [
	preload("res://resources/cutscene_frames/frame_1.png"),
	preload("res://resources/cutscene_frames/frame_2.png"),
	preload("res://resources/cutscene_frames/frame_3.png"),
	preload("res://resources/cutscene_frames/frame_4.png"),
	preload("res://resources/cutscene_frames/frame_5.png"),
	preload("res://resources/cutscene_frames/frame_7.png"),
	preload("res://resources/cutscene_frames/frame_8.png"),
	preload("res://resources/cutscene_frames/frame_6.png"),
	preload("res://resources/cutscene_frames/frame_9.png"),
]

var main_menu_scene: PackedScene = preload("res://Levels/3D Main Menu/3d_main_menu.tscn")

@onready var transition: Transition = %Transition


func _slide_on_gui_input(event: InputEvent):
	if !event.is_action_pressed("click"):
		return
	
	if slide_counter == 8:
		transition.change_scene(main_menu_scene)
		return
	
	slide_counter += 1
	
	await transition.fade_out()
	next_slide()


func next_slide():
	(%Slide as TextureRect).set_texture(slideList[slide_counter])
	@warning_ignore("return_value_discarded")
	transition.fade_in()


func _ready():
	Music.play(MusicPlayer.Song.Sienexilin)
	next_slide()

