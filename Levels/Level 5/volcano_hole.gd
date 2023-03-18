extends Area3D

@onready var volcano = %Volcano as StaticBody3D


func object_entered(object: Node):
	volcano.add_collision_exception_with(object)


func object_exited(object: Node):
	volcano.remove_collision_exception_with(object)
