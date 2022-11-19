extends Node

# Converts a time value from 0-1 to another value from 0-1 which can be inputted into lerp for smooth motion
func smoothify(t):
	return 3*t*t - 2*t*t*t
