extends Node

# TWEENING FUNCTIONS, takes an input from 0-1 and returns an output from 0-1. Assumes the time value is increasing linearly

# Smooths a time value such that the curve is horizontal at t = 0 & 1
func smoothify(t):
	return 3*t*t - 2*t*t*t

func smoothify_derivative(t):
	return 6*t - 6*t*t


# Goes up, goes flat halfway, and goes back down, all smoothly
func smooth_up_and_down(t):
	return unsmoothed_up_and_down(smoothify(t))

func smooth_up_and_down_derivative(t):
	# Chain rule
	return unsmoothed_up_and_down_derivative(smoothify(t)) * smoothify_derivative(t)


func unsmoothed_up_and_down(t):
	return 4*t - 4*t*t

func unsmoothed_up_and_down_derivative(t):
	return 4 - 8*t


# Increases fast, then slows down. Not smoothed
func fast_then_slow(t):
	return 5./3.*t - 2./3.*t*t
