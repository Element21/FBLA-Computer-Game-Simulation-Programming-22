extends Node3D


var bubble_velocity_scale = 1

var bubble: PackedScene = preload("res://objects/bubble/bubble.tscn")


func spawn_bubble():
	var new_bubble = bubble.instantiate()
	
	new_bubble.linear_velocity = Vector3(randf() - 0.5, 0, randf() - 0.5) * 2 * bubble_velocity_scale
	
	self.add_child(new_bubble)
