extends Node2D

var solved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attempt_puzzle_solve(body):
	for keyItem in body.inventory.keyItemsInventory:
		if keyItem.name == "Small Key":
			print("opened!")
			queue_free()
		else:
			print("not opened...")
	if body.inventory.keyItemsInventory.is_empty():
		print("not opened...")

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		attempt_puzzle_solve(body)
	pass # Replace with function body.
