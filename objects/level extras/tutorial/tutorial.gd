extends Control

class_name Tutorial


@onready var camera: Camera3D = self.get_parent()
@onready var phrase_label: Label = %"Phrase label"

func show_text(text: String, position: Vector3, offset: Vector2 = Vector2(0, 0)):
	await hide_text()
	
	phrase_label.text = text
	phrase_label.reset_size()
	phrase_label.position = camera.unproject_position(position) + offset - phrase_label.size / 2
	
	var tween = get_tree().create_tween()
	tween.tween_property(phrase_label, "modulate", Color(1., 1., 1., 1.), 0.5).set_trans(Tween.TRANS_SINE)
	await tween.finished


func hide_text() -> Signal:
	var tween = get_tree().create_tween()
	tween.tween_property(phrase_label, "modulate", Color(1., 1., 1., 0.), 0.5).set_trans(Tween.TRANS_SINE)
	return tween.finished


func _ready():
	phrase_label.modulate = Color(1., 1., 1., 0.)
