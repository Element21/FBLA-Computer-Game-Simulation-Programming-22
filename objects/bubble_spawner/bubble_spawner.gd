extends Spatial


export(NodePath) onready var level = get_node(level) as Level


var bubble_velocity_scale = 1

var bubble: PackedScene = preload("res://objects/bubble/bubble.tscn")


func spawn_bubble():
	var new_bubble = bubble.instance()
	new_bubble.level = level
	
	new_bubble.linear_velocity = Vector3(randf() - 0.5, 0, randf() - 0.5) * 2 * bubble_velocity_scale
	
	self.add_child(new_bubble)
