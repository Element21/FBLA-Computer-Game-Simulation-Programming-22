extends RigidBody3D


# When the bubble is popped, the node isn't deleted immediately because that would prevent the sound and the particles from happening

var probability_of_pop_in_one_second = 0.5


func maybe_pop(delta: float):
	# Pop if this bubble hasn't been popped before, and the random roll succeeds
	if is_instance_valid(%"Bubble mesh") && randf() < probability_of_pop_in_one_second * delta:
		%"Bubble mesh".queue_free()
		
		%"Pop sound".play()
		%Particles.emitting = true
		
		%"Delete timer".start()


func delete():
	self.queue_free()
