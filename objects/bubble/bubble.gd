extends RigidBody3D

class_name Bubble


# When the bubble is popped, the node isn't deleted immediately because that would prevent the sound and the particles from happening

var probability_of_pop_in_one_second = 0.5

@onready var bubble_mesh: MeshInstance3D = %"Bubble mesh"


func maybe_pop(delta: float):
	# Pop if this bubble hasn't been popped before, and the random roll succeeds
	if is_instance_valid(bubble_mesh) && randf() < probability_of_pop_in_one_second * delta:
		bubble_mesh.queue_free()
		
		(%"Pop sound" as AudioStreamPlayer3D).play()
		(%Particles as GPUParticles3D).emitting = true
		
		await get_tree().create_timer(1.).timeout
		self.queue_free()
