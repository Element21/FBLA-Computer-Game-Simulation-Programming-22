extends Button


export(Resource) var scene_to_switch_to


func _ready():
	
	var _status = self.connect("pressed", self, "on_input")


func on_input():
	
	var _status = get_tree().change_scene_to(scene_to_switch_to)
