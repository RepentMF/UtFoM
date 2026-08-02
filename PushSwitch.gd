#PushSwitch.gd
extends Node2D

var ID
var sprite
var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ID = get_meta("ID")
	sprite = get_node("Sprite2D")
	if GlobalDataManager.switchesList[ID - 1]:
		pressed = true
	pass # Replace with function body.

func _physics_process(delta):
	if pressed && sprite.animation != "pressed":
		sprite.animation = "pressed"
		GlobalDataManager.change_switch_data(ID)
	pass

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		pressed = true
	pass # Replace with function body.
