extends Node

class_name Utils


static func search(a: Array, filter: Callable, throw: bool = true) -> Variant:
	for v in a:
		if filter.call(v):
			return v
	
	if throw:
		@warning_ignore("assert_always_false") # That's the point
		assert(false)
	
	return null
