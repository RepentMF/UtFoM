#PowerBox.gd
extends Node2D

var ID
var solution = []
var direction

var sprite
var player
var switched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ID = get_meta("ID")
	sprite = get_node("Sprite2D")
	direction = get_meta("Direction")
	if GlobalDataManager.powerBoxesList[ID - 1]:
		switched = true
	if !switched:
		solution = get_meta("Solution")
		sprite.animation = direction + "_off"
	else:
		sprite.play(direction + "_on")
	match direction:
		"down":
			get_node("Area2D/CollisionShape2D").disabled = false
		"up":
			sprite.position -= Vector2(10, 0)
			get_node("Area2D2/CollisionShape2D").disabled = false
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("action_juggle_attack") && sprite.animation.contains("off") && player != null:
		attempt_puzzle_solve()
	if switched && sprite.animation.contains("off"):
		sprite.play(direction + "_switched_on")
		GlobalDataManager.change_power_box_data(ID)
	pass

func attempt_puzzle_solve():
	for ID in solution:
		if GlobalDataManager.powerBoxesList[ID - 1]:
			solution.erase(ID)
	if solution.is_empty():
		switched = true
	else:
		sprite.play(direction + "_switch_failed")
	pass

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter") && !switched:
		player = body
		player.isNearInteractable = true
		#print("press a on controller. press d on keyboard.")
	pass # Replace with function body.

func _on_area_2d_body_exited(body):
	if body.name.contains("PlayerCharacter"):
		body.isNearInteractable = false
		player = null

func _on_sprite_2d_animation_finished():
	if sprite.animation.contains("_switched_on"):
		sprite.play(direction + "_on")
	elif sprite.animation.contains("switch_failed"):
		sprite.play(direction + "_off")
	pass # Replace with function body.
