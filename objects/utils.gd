extends Node

# Converts a time value from 0-1 to another value from 0-1 which can be inputted into lerp for smooth motion
func smoothify(t):
	return 3*t*t - 2*t*t*t

func smoothify_derivative(t):
	return 6*t - 6*t*t


func smooth_up_and_down(t):
	return unsmoothed_up_and_down(smoothify(t))

func smooth_up_and_down_derivative(t):
	# Chain rule
	return unsmoothed_up_and_down_derivative(smoothify(t)) * smoothify_derivative(t)


func unsmoothed_up_and_down(t):
	return 4*t - 4*t*t

func unsmoothed_up_and_down_derivative(t):
	return 4 - 8*t


func fast_then_slow(t):
	return -t * (t - 2.5) / 1.5
