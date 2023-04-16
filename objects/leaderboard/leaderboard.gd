extends Control

class_name Leaderboard


@export var max_entries: int = 10


func show_leaderboard_for(level_index: int):
	var leaderboard_entries = LeaderboardManager.leaderboard_data.get_sorted_leaderboard_for(level_index)
	
	# Remove the previous leaderboard data
	remove_children(%Names)
	remove_children(%Scores)
	
	for i in range(0, min(max_entries, leaderboard_entries.size())):
		var name_label = Label.new()
		name_label.text = leaderboard_entries[i][0]
		name_label.add_theme_font_size_override("font_size", 20)
		%Names.add_child(name_label)
		
		var score_label = Label.new()
		score_label.text = String.num_int64(leaderboard_entries[i][1])
		score_label.add_theme_font_size_override("font_size", 20)
		%Scores.add_child(score_label)


func remove_children(node: Node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
