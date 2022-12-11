extends Spatial

export var spawn_point: Vector3 = Vector3(0, 0, 25)
export var initial_velocity: Vector3 = Vector3()
export var spawn_amnt: int = 10

#export(NodePath) onready var level_node
#onready var level = get_node(level_node)

var rng = RandomNumberGenerator.new()

var alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

var packed_scene = preload("res://objects/letter/letter.tscn")

onready var letter = packed_scene.instance()

func spawn_letter(sp: Vector3=spawn_point, iv: Vector3=initial_velocity, sa: int = spawn_amnt):
	for _i in range(sa):
		letter.add_to_group("Letter")
		rng.randomize()
#		letter.level = level
		letter.which_letter = alphabet[randi() % alphabet.size()] # Pick random letter from "alphabet" to spawn
		add_child(letter)

	# Get a list of nodes that are in the "Letter" group, this is useful for mass selection
	var spawned_letters = get_tree().get_nodes_in_group("Letter")
	
	for spawned_letter in spawned_letters:
		# Request a position change from the physics engine, this is required for rigidbodies
		PhysicsServer.body_set_state(spawned_letter.get_rid(), PhysicsServer.BODY_STATE_TRANSFORM, Transform.IDENTITY.translated(sp + Vector3(rng.randf_range(0, 50), rng.randf_range(0, 50), 0)))
		# Apply velocity to letters
		spawned_letter.apply_central_impulse(iv)


func _ready():
	spawn_letter()


func _on_Timer_timeout():
	print("Spawn timer triggered")
	spawn_letter()
