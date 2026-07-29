extends Node2D

var ID

var sprite
var player
var switched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ID = get_meta("ID")
	sprite = get_node("Sprite2D")
	sprite.animation = "off"
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("action_juggle_attack") && sprite.animation == "off" && player != null:
		switched = true
	if switched && sprite.animation == "off":
		sprite.play("switched_on")
		GlobalDataManager.change_power_box_data(ID)
	pass

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter") && !switched:
		player = body
		player.isNearInteractable = true
		print("press a on controller. press d on keyboard.")
	pass # Replace with function body.

func _on_area_2d_body_exited(body):
	if body.name.contains("PlayerCharacter"):
		body.isNearInteractable = false
		player = null

func _on_sprite_2d_animation_finished():
	if sprite.animation == "switched_on":
		sprite.play("on")
	pass # Replace with function body.
