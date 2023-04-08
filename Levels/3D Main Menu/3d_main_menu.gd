extends Node


var start_pos = Vector3(5, 3.5, 7)
var can_offset = Vector3(0, 3, 4)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event: InputEvent):
	if event.is_action_pressed("click"):
		var mouse_pos = get_viewport().get_mouse_position()
		
		%RayCast.global_position = %Camera.global_position
		%RayCast.target_position = %Camera.project_ray_normal(mouse_pos) * 1000
		
		await get_tree().process_frame
		
		var maybe_can = %RayCast.get_collider()
		
		
		if maybe_can != null && maybe_can is LevelCan:
			var can: LevelCan = maybe_can
			
			var tween = get_tree().create_tween()
			tween.tween_property(%Camera, "position", can.position + can_offset, .5).set_trans(Tween.TRANS_SINE)
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(%Camera, "position", start_pos, .5).set_trans(Tween.TRANS_SINE)
