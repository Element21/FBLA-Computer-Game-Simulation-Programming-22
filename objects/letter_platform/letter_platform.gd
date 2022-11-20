extends Node


var flip_time = 1

var time = null


func flip():
	time = 0


func _process(delta):
	
	if time != null:
		
		self.rotation_degrees.x = lerp(0, -360, Utils.smoothify(time / flip_time))
		
		time += delta
		
		if time > flip_time:
			time = null
