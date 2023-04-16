extends ColorRect

class_name Transition


func _ready():
	@warning_ignore("return_value_discarded")
	fade_in()

 
func fade_in() -> Signal:
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_method(func(v): (self.material as ShaderMaterial).set_shader_parameter("cutoff", v), 0., 1., .3).set_trans(Tween.TRANS_SINE)
	return tween.finished


func fade_out() -> Signal:
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_method(func(v): (self.material as ShaderMaterial).set_shader_parameter("cutoff", v), 1., 0., .3).set_trans(Tween.TRANS_SINE)
	return tween.finished


func change_scene(scene: PackedScene):
	await fade_out()
	assert(get_tree().change_scene_to_packed(scene) == OK)
