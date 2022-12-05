extends RigidBody


# This is assigned by BubbleSpawner (WHY ARE NODE PATHS RELATIVE AAAAAAAAA)
var level: Level

var surface = 8.73
var half_life = 1


func _ready():
	level.bubbles_in_play.push_back(self)


func _process(delta):
	if self.global_translation.y > surface:
		self.global_translation.y = surface
		
		if randf() < 1 - pow((1 / half_life) * 0.5, delta):
			level.bubbles_in_play.remove(level.bubbles_in_play.find(self))
			self.queue_free()
