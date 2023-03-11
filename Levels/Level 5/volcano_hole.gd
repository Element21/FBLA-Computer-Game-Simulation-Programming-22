extends Area3D


func object_entered(object: Node):
	%Volcano.add_collision_exception_with(object)


func object_exited(object: Node):
	%Volcano.remove_collision_exception_with(object)
