extends Resource

class_name LeaderboardData

# Array, each entry contains leaderboard data for the level with the same index (first value contains data for level 1)
# Each entry is a dictionary from `name` to `highest score`
export var data: Array = [{}]
