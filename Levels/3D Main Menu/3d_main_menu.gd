extends Node


var start_pos = Vector3(5, 3.5, 7)
var can_offset = Vector3(0, 3, 4)
var maybe_can_focusing_on = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	
	%RayCast.global_position = %Camera.global_position
	%RayCast.target_position = %Camera.project_ray_normal(mouse_pos) * 1000



func _input(event: InputEvent):
	if event.is_action_pressed("click"):
		var maybe_can = %RayCast.get_collider()
		
		if maybe_can != null && maybe_can is LevelCan:
			var can: LevelCan = maybe_can
			
			var tween = get_tree().create_tween()
			tween.tween_property(%Camera, "position", can.position + can_offset, .5).set_trans(Tween.TRANS_SINE)
			
			can.show_level_data()
			
			maybe_can_focusing_on = can
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(%Camera, "position", start_pos, .5).set_trans(Tween.TRANS_SINE)
			
			if maybe_can_focusing_on:
				maybe_can_focusing_on.hide_level_data()
				maybe_can_focusing_on = null
