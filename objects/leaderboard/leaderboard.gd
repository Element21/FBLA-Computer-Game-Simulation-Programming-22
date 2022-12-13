extends Control

class_name Leaderboard


export(int) var max_entries = 10


export(NodePath) onready var names = get_node(names) as VBoxContainer
export(NodePath) onready var scores = get_node(scores) as VBoxContainer


func show_leaderboard_for(level_index: int):
	var leaderboard_entries = LeaderboardManager.leaderboard_data.get_sorted_leaderboard_for(level_index)
	
	# Remove the previous leaderboard data
	remove_children(names)
	remove_children(scores)
	
	for i in range(0, min(max_entries, leaderboard_entries.size())):
		var name_label = Label.new()
		name_label.text = leaderboard_entries[i][0]
		names.add_child(name_label)
		
		var score_label = Label.new()
		score_label.text = String(leaderboard_entries[i][1])
		scores.add_child(score_label)


func remove_children(node: Node):
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()
