extends RigidBody


# This is assigned by BubbleSpawner (WHY ARE NODE PATHS RELATIVE AAAAAAAAA)
var level: Level

onready var bubble_mesh = get_node("Bubble mesh")
onready var pop_sound = get_node("Pop sound")

var probability_of_pop_in_one_second = 0.5


func _ready():
	level.bubbles_in_play.push_back(self)


func _process(delta):
	if is_instance_valid(bubble_mesh) && randf() < probability_of_pop_in_one_second * delta:
		level.bubbles_in_play.remove(level.bubbles_in_play.find(self))
		bubble_mesh.queue_free()
		pop_sound.play()


func finished_playing_sound():
	self.queue_free()
