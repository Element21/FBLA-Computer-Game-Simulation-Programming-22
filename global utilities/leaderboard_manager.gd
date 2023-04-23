extends Node

var player_name = "test"

var leaderboard_data: LeaderboardData


func _ready():
	# Load the leaderboard data from storage, or create a new one
	if ResourceLoader.exists("user://leaderboard_data.res"):
		leaderboard_data = ResourceLoader.load("user://leaderboard_data.res")
	else:
		leaderboard_data = LeaderboardData.new()


func set_player_name(new_player_name: String):
	player_name = new_player_name


# Add a score to the leaderboard, does nothing if it isn't a high score
func add_score(level_index: int, score: int):
	var leaderboard = leaderboard_data.get_leaderboard_for(level_index)
	
	if !leaderboard.has(player_name):
		leaderboard[player_name] = 0
	
	if score >= leaderboard[player_name]:
		leaderboard[player_name] = score
		assert(OK == ResourceSaver.save(leaderboard_data, "user://leaderboard_data.res"))


## Returns a dictionary mapping names to scores
func get_highscore_for(level_index: int):
	return leaderboard_data.get_leaderboard_for(level_index).get(player_name, null)


func is_level_unlocked(level_index: int) -> bool:
	if level_index == 0:
		return true
	
	var leaderboard_for_previous_level = leaderboard_data.get_leaderboard_for(level_index - 1)
	
	return leaderboard_for_previous_level.has(player_name)
