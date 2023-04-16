extends Node3D

class_name FountainOutput


@export var vertical_velocity = 5
@export var horizontal_velocity = 3


# Teleport the letter to the output, give it a random velocity
# The teleportation is necessary because I found that launching it through the tube was inconsistent
func launch_object(object: RigidBody3D):
	object.global_position = self.global_position
	
	var angle = randf() * PI * 2
	
	object.linear_velocity = Vector3(sin(angle) * horizontal_velocity, vertical_velocity, cos(angle) * horizontal_velocity)
