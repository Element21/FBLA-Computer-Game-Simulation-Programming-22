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
	
	leaderboard_data.data[level_index][player_name] = score


func highscore_for(level_index: int):
	return leaderboard_data.data[level_index].get(player_name, null)
