#PuzzlePowerDoor.gd
extends Node2D

var direction
var solution = []
var solutionCount
var solved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	solution = get_meta("Solution")
	solutionCount = solution.size()
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
	attempt_puzzle_solve()
	pass # Replace with function body.

func _physics_process(delta):
	if GlobalDataManager.dataChanged:
		attempt_puzzle_solve()
	pass

func attempt_puzzle_solve():
	var rememberCount = solutionCount
	while solutionCount > -1:
		if GlobalDataManager.powerBoxesList[solutionCount - 1]:
			solution.erase(solutionCount)
		solutionCount = solutionCount - 1
	solutionCount = rememberCount
	if solution.is_empty():
		queue_free()
	pass
