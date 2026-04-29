extends Node2D

var solved = false
var killroomList
var killroomCount
var enemyNames = []
var missingCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	killroomList = get_meta("KillroomList")
	for child in get_parent().get_children():
		for enemy in killroomList:
			if child.name.contains(enemy):
				enemyNames.push_front(enemy)
				print(enemy)
	print()
	pass # Replace with function body.

func attempt_puzzle_solve():
	if enemyNames.is_empty():
		solved = true
		print("door open!")
	else:
		print(enemyNames.size())

func _on_child_exiting_tree(node):
	for enemy in enemyNames:
		if node.name.contains(enemy):
			enemyNames.erase(enemy)
			print(enemy)
			break
	attempt_puzzle_solve()
	pass # Replace with function body.
