extends Resource

class_name LeaderboardData

# Array, each entry contains leaderboard data for the level with the same index (first value contains data for level 1)
# Each entry is a dictionary from `name` to `highest score`
export var data: Array = [{
	test = 5,
	bruh = 9,
}]


class LeaderboardDataSorter:
	static func sort_ascending(a, b):
		return a[0] < b[0]


func get_sorted_leaderboard_for(idx: int) -> Array:
	var data_dictionary: Dictionary = data[idx]
	
	var data_array = []
	
	for key in data_dictionary.keys():
		data_array.push_back([key, data_dictionary[key]])
	
	data_array.sort_custom(LeaderboardDataSorter, "sort_ascending")
	
	return data_array