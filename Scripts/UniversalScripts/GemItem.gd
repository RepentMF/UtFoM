#GemItem.gd
extends Node2D

var invController

var iName
var description
var boolToChange
var gemColor

# Called when the node enters the scene tree for the first time.
func _ready():
	invController = get_parent().get_node("InventoryController")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		var gemItem = invController.new_gem_item_add(iName, description, boolToChange, gemColor)
		body.inventory.gemsInventory.push_back(gemItem)
		queue_free()
	pass # Replace with function body.
