extends Spatial

class_name FountainOutput


export var vertical_velocity = 5
export var horizontal_velocity = 3


func launch_object(object: RigidBody):
	object.global_translation = self.global_translation
	
	var angle = randf() * PI * 2
	
	object.linear_velocity = Vector3(sin(angle) * horizontal_velocity, vertical_velocity, cos(angle) * horizontal_velocity)
