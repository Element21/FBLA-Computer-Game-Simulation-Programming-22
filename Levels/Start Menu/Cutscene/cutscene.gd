extends Control

var slide_counter = 0

var slideList: Array[String] = [
	"res://resources/cutscene_frames/frame_1.png",
	"res://resources/cutscene_frames/frame_2.png",
	"res://resources/cutscene_frames/frame_3.png",
	"res://resources/cutscene_frames/frame_4.png",
	"res://resources/cutscene_frames/frame_5.png",
	"res://resources/cutscene_frames/frame_7.png",
	"res://resources/cutscene_frames/frame_8.png",
	"res://resources/cutscene_frames/frame_6.png",
	"res://resources/cutscene_frames/frame_9.png",
	"res://resources/cutscene_frames/how2play.png"
]

@onready var transition: Transition = %Transition


func _slide_on_gui_input(event: InputEvent):
	if !event.is_action_pressed("click"):
		return
	
	if slide_counter == slideList.size() - 1:
		transition.change_scene(load("res://Levels/3D Main Menu/3d_main_menu.tscn"))
		return
	
	slide_counter += 1
	
	await transition.fade_out()
	next_slide()


func next_slide():
	(%Slide as TextureRect).set_texture(ResourceLoader.load_threaded_get(slideList[slide_counter]))
	@warning_ignore("return_value_discarded")
	transition.fade_in()


func _ready():
	for slide in slideList:
		assert(ResourceLoader.load_threaded_request(slide) == OK)
	
	Music.play(MusicPlayer.Song.Sienexilin)
	next_slide()

