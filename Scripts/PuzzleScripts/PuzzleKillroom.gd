extends Node2D

var solved = false
var killroomList
var killroomCount
var childrenNames = []
var missingCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	killroomList = get_meta("KillroomList")
	for child in get_parent().get_children():
		childrenNames.push_front(child.name)
		print(child.name)
	for enemy in killroomList:
		if enemy.name.contains("")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if !solved:
	#	attempt_puzzle_solve()
	pass

func attempt_puzzle_solve():
	for enemy in killroomList:
		if childrenNames.has(enemy.name):
			missingCount += 1
	if missingCount == killroomCount:
		solved = true
		print("door open!")
	else:
		print(missingCount, ", ", killroomCount)

func _on_child_exiting_tree(node):
	var removed = false
	for child in childrenNames:
		if child.name == node.name:
			childrenNames.remove(child)
			break
	attempt_puzzle_solve()
	pass # Replace with function body.
