#PuzzleLockedDoor.gd
extends Node2D

var ID

var solved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ID = get_meta("ID")
	if GlobalDataManager.doorsList[ID - 1]:
		solved = true
	if solved:
		queue_free()
	pass # Replace with function body.

func attempt_puzzle_solve(body):
	if body.inventory.keyItemsInventory.is_empty():
		print("not opened...")
	for keyItem in body.inventory.keyItemsInventory:
		if keyItem.name == "Small Key":
			body.inventory.keyItemsInventory.erase(keyItem)
			print("opened!")
			queue_free()
		else:
			print("not opened...")

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		attempt_puzzle_solve(body)
	pass # Replace with function body.
