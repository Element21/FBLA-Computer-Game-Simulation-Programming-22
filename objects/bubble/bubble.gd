extends RigidBody


# When the bubble is popped, the node isn't deleted immediately because that would prevent the sound and the particles from happening

onready var bubble_mesh = get_node("Bubble mesh")
onready var pop_sound = get_node("Pop sound")
onready var particles = get_node("Particles")
onready var delete_timer = get_node("Delete timer")

var probability_of_pop_in_one_second = 0.5


func maybe_pop(delta: float):
	# Pop if this bubble hasn't been popped before, and the random roll succeeds
	if is_instance_valid(bubble_mesh) && randf() < probability_of_pop_in_one_second * delta:
		bubble_mesh.queue_free()
		
		pop_sound.play()
		particles.emitting = true
		
		delete_timer.start()


func delete():
	self.queue_free()
