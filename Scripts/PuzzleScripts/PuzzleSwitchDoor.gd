#PuzzleSwitchDoor.gd
extends Node2D

var direction
var solution = []
var solved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	solution = get_meta("Solution")
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
	for ID in solution:
		if GlobalDataManager.switchesList[ID - 1]:
			solution.erase(ID)
	if solution.is_empty():
		queue_free()
	#else:
	#	print("not all switches pressed")
	pass
