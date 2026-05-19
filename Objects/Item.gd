extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		body.get_node("Inventory").keyItemsInventory.push_back(self)
		queue_free()
	pass # Replace with function body.
