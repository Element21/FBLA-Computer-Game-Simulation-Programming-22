extends Area


export(NodePath) onready var volcano = get_node(volcano) as StaticBody


func object_entered(object: Node):
	volcano.add_collision_exception_with(object)


func object_exited(object: Node):
	volcano.remove_collision_exception_with(object)
