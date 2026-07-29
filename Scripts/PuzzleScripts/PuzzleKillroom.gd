#PuzzleKillroom.gd
extends Node2D

var solved = false
var direction
var killroomList
var killroomCount
var enemyNames = []
var missingCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if !solved:
		killroomList = get_meta("KillroomList")
		for child in get_parent().get_children():
			for enemy in killroomList:
				if child.name.contains(enemy):
					enemyNames.push_front(enemy)
		direction = get_meta("Direction")
		get_node("Sprite2D").animation = direction
		match direction:
			"down":
				get_node("StaticBody2D/CollisionShape2D").disabled = false
			"left":
				get_node("StaticBody2D2/CollisionShape2D").disabled = false
			"up":
				get_node("StaticBody2D3/CollisionShape2D").disabled = false
			"right":
				get_node("StaticBody2D2/CollisionShape2D").disabled = false
	pass # Replace with function body.

func attempt_puzzle_solve():
	if enemyNames.is_empty():
		solved = true
		queue_free()
	else:
		print("???")

func _on_child_exiting_tree(node):
	for enemy in enemyNames:
		if node.name.contains(enemy):
			enemyNames.erase(enemy)
			break
	attempt_puzzle_solve()
	pass # Replace with function body.
