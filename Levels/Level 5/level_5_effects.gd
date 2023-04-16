extends Node3D


@export var camera: Camera3D

@onready var start_position = camera.position

var target_shake_amt = 0.
var shake_amt = 0.

func _process(delta):
	if target_shake_amt > 0.:
		target_shake_amt -= delta * 10
	
	target_shake_amt = max(target_shake_amt, 0.)
	
	camera.position = start_position + Vector3(0, shake_amt * sin(Time.get_ticks_msec() as float / 30), 0)
	camera.rotation.z = shake_amt * sin(Time.get_ticks_msec() as float / 20) * 0.2
	
	shake_amt = lerp(shake_amt, target_shake_amt, delta * 5)


func erupt():
	target_shake_amt = 1.
	
#	for letter in get_tree().get_nodes_in_group("Letters") as Array[RigidBody3D]:
#		var theta = randf() * TAU
#		letter.apply_central_impulse(Vector3(2 * sin(theta), 5., 2 * cos(theta)) * letter.mass)

