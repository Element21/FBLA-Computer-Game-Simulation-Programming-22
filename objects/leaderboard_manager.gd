extends Node

var player_name = "test"

var leaderboard_data: LeaderboardData


func _ready():
	if ResourceLoader.exists("user://leaderboard_data.res"):
		leaderboard_data = ResourceLoader.load("user://leaderboard_data.res")
	else:
		leaderboard_data = LeaderboardData.new()


func set_player_name(new_player_name: String):
	player_name = new_player_name


func add_score(level_index: int, score: int):
	var leaderboard = leaderboard_data.get_leaderboard_for(level_index)
	
	if !leaderboard.has(player_name):
		leaderboard[player_name] = 0
	
	if score >= leaderboard[player_name]:
		leaderboard[player_name] = score
		ResourceSaver.save("user://leaderboard_data.res", leaderboard_data)


func highscore_for(level_index: int):
	return leaderboard_data.get_leaderboard_for(level_index).get(player_name, null)


func level_unlocked(level_index: int) -> bool:
	if level_index == 0:
		return true
	
	var leaderboard_for_previous_level = leaderboard_data.get_leaderboard_for(level_index - 1)
	
	return leaderboard_for_previous_level.has(player_name)
