extends Spatial

export var spawn_point: Vector3 = Vector3(0, 25, 0)
export var initial_velocity: Vector3 = Vector3(0, 0, 0)
export var spawn_amnt: int = 10
export(NodePath) var level

onready var packed_scene = preload("res://objects/letter/letter.tscn")


func spawn_letter(sp: Vector3=spawn_point, iv: Vector3=initial_velocity, sa: int = spawn_amnt):
	for _i in range(sa):
		var letter = packed_scene.instance()
		add_child(letter)
		letter.add_to_group("Letter")
		letter.global_transform.origin = sp
		letter.apply_central_impulse(iv)

func _ready():
	get_node(level).connect("level_ended", self, "_on_level_ended")

func _on_level_ended():
	print("level ended")
	$"Timer".stop()

func _on_Timer_timeout():
	spawn_letter()
