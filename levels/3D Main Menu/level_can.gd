extends Area3D

class_name LevelCan

# https://github.com/godotengine/godot-demo-projects/tree/master/viewport/2d_in_3d

@onready var level_data_viewport: SubViewport = %"Level data viewport"
@onready var play_button_viewport: SubViewport = %"Play button viewport"
@onready var highscore_label: Label = %Highscore
@onready var popup: Node3D = %Popup
@onready var animation_player: AnimationPlayer = can.find_child("AnimationPlayer")
@onready var start_pos = self.position
@onready var locked = !LeaderboardManager.is_level_unlocked(level_idx)

@export var level_idx: int
@export var can: Node3D

static func come_out_amt() -> Vector3: return Vector3(0, 0, 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	if locked:
		%"Shadow caster".show()
		%Button.text = "Locked"
		%Button.modulate = Color(1., 1., 1., .5)
		%PlayButton.locked = true
	
	assert(animation_player != null)
	
	(%Leaderboard as Leaderboard).show_leaderboard_for(level_idx)
	
	(%"Level name" as Label).text = "Level " + String.num_int64(level_idx + 1)
	
	var highscore = LeaderboardManager.get_highscore_for(level_idx)
	
	if highscore == null:
		highscore_label.text = ""
	else:
		highscore_label.text = "Your highscore: " + String.num_int64(highscore)
	


func show_level_data():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.set_parallel()
	@warning_ignore("return_value_discarded")
	tween.tween_property(popup, "position", Vector3(0, 7.5, -2.8), 0.5).set_trans(Tween.TRANS_SINE)
	@warning_ignore("return_value_discarded")
	tween.tween_property(self, "position", start_pos + LevelCan.come_out_amt(), 0.5).set_trans(Tween.TRANS_SINE)


func hide_level_data():
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.set_parallel()
	@warning_ignore("return_value_discarded")
	tween.tween_property(popup, "position", Vector3(0, 20, -2.8), 0.5).set_trans(Tween.TRANS_SINE)
	@warning_ignore("return_value_discarded")
	tween.tween_property(self, "position", start_pos, 0.5).set_trans(Tween.TRANS_SINE)


func play_can_open_animation():
	# I can't play two animations at once, so I have to do this
	# I tried using an AnimationTree but that didn't work. This works just as well though.
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_property(can.find_child("Can Top"), "blend_shapes/Can Top.001", 1, 1.)
	
	animation_player.play("Open TabAction001")
