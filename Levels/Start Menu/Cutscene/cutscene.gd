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

var main_menu_scene: PackedScene = preload("res://Levels/Main Menu/main_menu.tscn")

func fadeIn():
	%Transition.animation_player.play("fadeIn")

func fadeOut():
	%Transition.animation_player.play("fadeOut")

func _slide_on_gui_input(event: InputEvent):
	if !event.is_action_pressed("click"):
		return
	
	if slide_counter == 8:
		get_tree().change_scene_to_packed(main_menu_scene)
		return
	
	slide_counter += 1
	fadeOut()


func fade_out_done(anim_name: String):
	if anim_name != "fadeOut":
		return
	
	%Slide.set_texture(slideList[slide_counter])
	fadeIn()


func _ready():
	self.visible = true
	fade_out_done("fadeOut")
	%Transition.animation_player.connect("animation_finished", fade_out_done)
