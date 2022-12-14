extends Spatial

export var upward_velocity: float = 0
export var horizontal_velocity: float = 2
export var spawn_amnt: int = 1
export var spawn_interval: float = 1.0
export(NodePath) var level

onready var timer = $Timer

onready var packed_scene = preload("res://objects/letter/letter.tscn")


func spawn_letters():
	for _i in range(spawn_amnt):
		var letter = packed_scene.instance()
		add_child(letter)
		letter.add_to_group("Letter")
		
		letter.apply_central_impulse(Vector3(0, upward_velocity, 0))
		
		var random_angle = randf() * PI * 2
		letter.apply_central_impulse(Vector3(cos(random_angle), 0, sin(random_angle)) * horizontal_velocity)


func _ready():
	get_node(level).connect("level_ended", self, "_on_level_ended")
	timer.wait_time = spawn_interval


func _on_level_ended():
	timer.stop()


func _on_Timer_timeout():
	spawn_letters()
