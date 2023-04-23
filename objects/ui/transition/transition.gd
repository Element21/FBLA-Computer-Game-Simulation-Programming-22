extends ColorRect

class_name Transition


func _ready():
	@warning_ignore("return_value_discarded")
	fade_in()

var current_tween = null

func _fade_to(cutoff: float) -> Signal:
	var initial_value = (self.material as ShaderMaterial).get_shader_parameter("cutoff")
	
	if current_tween != null && current_tween.is_running():
		current_tween.stop()
	
	var tween = get_tree().create_tween()
	@warning_ignore("return_value_discarded")
	tween.tween_method(func(v): (self.material as ShaderMaterial).set_shader_parameter("cutoff", v), initial_value, cutoff, .3).set_trans(Tween.TRANS_SINE)
	current_tween = tween
	return tween.finished
 

func fade_in() -> Signal:
	return _fade_to(1.)


func fade_out() -> Signal:
	return _fade_to(0.)


func change_scene(scene: PackedScene):
	await fade_out()
	assert(get_tree().change_scene_to_packed(scene) == OK)
