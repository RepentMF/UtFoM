#PushSwitch.gd
extends Node2D

var sprite
var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite2D")
	pass # Replace with function body.

func _physics_process(delta):
	if pressed && sprite.animation != "pressed":
		sprite.animation = "pressed"
	pass

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		pressed = true
	pass # Replace with function body.
