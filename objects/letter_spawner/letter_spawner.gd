extends Node3D

@export var upward_velocity: float = 0
@export var horizontal_velocity: float = 2
@export var spawn_amnt: int = 1
@export var spawn_interval: float = 1.0
@export var level: Level

@onready var packed_scene = preload("res://objects/letter/letter.tscn")

@onready var timer: Timer = %Timer

func spawn_letters():
	for _i in range(spawn_amnt):
		var letter: Letter = packed_scene.instantiate()
		add_child(letter)
		letter.add_to_group("Letter")
		
		letter.apply_central_impulse(Vector3(0, upward_velocity, 0))
		
		var random_angle = randf() * PI * 2
		letter.apply_central_impulse(Vector3(cos(random_angle), 0, sin(random_angle)) * horizontal_velocity)


func _ready():
	assert(OK == level.connect("level_ended", func(): timer.stop()))
	timer.wait_time = spawn_interval
