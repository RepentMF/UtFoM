#PuzzleSwitchDoor.gd
extends Node2D

var direction
var solved = false

# Called when the node enters the scene tree for the first time.
func _ready():
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

func attempt_puzzle_solve(body):
	pass

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		attempt_puzzle_solve(body)
	pass # Replace with function body.
