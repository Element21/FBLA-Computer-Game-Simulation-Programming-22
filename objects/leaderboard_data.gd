extends Resource

class_name LeaderboardData

## Array, each entry contains leaderboard data for the level with the same index (first value contains data for level 1)
## Each entry is a dictionary from `name` to `highest score`
@export var data: Array[Dictionary] = []


class LeaderboardDataSorter:
	static func sort_descending(a, b):
		return a[1] > b[1]


## Returns an array where each entry is an array of [name, score], sorted by score
func get_sorted_leaderboard_for(idx: int) -> Array:
	var data_dictionary = get_leaderboard_for(idx)
	
	var data_array = []
	
	for key in data_dictionary.keys():
		data_array.push_back([key, data_dictionary[key]])
	
	data_array.sort_custom(Callable(LeaderboardDataSorter,"sort_descending"))
	
	return data_array


## Returns a dictionary mapping names to scores
func get_leaderboard_for(idx: int) -> Dictionary:
	if data.size() <= idx:
		@warning_ignore("return_value_discarded")
		data.resize(idx + 1)
	
	if data[idx] == null:
		data[idx] = {}
	
	return data[idx]
