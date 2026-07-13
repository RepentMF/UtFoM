extends Node2D

var invController

var direction
var opened
var isNearTreasure = false

var treasureType
var iName
var description
var light
var juggle
var heavy

func _ready():
	invController = get_parent().get_node("InventoryController")
	direction = get_meta("direction")
	treasureType = get_meta("treasureType")
	iName = get_meta("iName")
	description = get_meta("description")
	match treasureType:
		"weapon":
			light = get_meta("light")
			juggle = get_meta("juggle")
			heavy = get_meta("heavy")
	pass

func _process(delta):
	if !opened:
		match direction:
			"down":
				get_node("Area2D").rotation = 0
				get_node("Sprite2D").animation = "down_shut"
			"left":
				get_node("Area2D").rotation = PI / 2
				get_node("Sprite2D").animation = "left_shut"
			"up":
				get_node("Area2D").rotation = PI
				get_node("Sprite2D").animation = "up_shut"
			"right":
				get_node("Area2D").rotation = -PI / 2
				get_node("Sprite2D").animation = "right_shut"
	else:
		match direction:
			"down":
				get_node("Area2D").rotation = 0
				get_node("Sprite2D").animation = "down_open"
			"left":
				get_node("Area2D").rotation = PI / 2
				get_node("Sprite2D").animation = "left_open"
			"up":
				get_node("Area2D").rotation = PI
				get_node("Sprite2D").animation = "up_open"
			"right":
				get_node("Area2D").rotation = -PI / 2
				get_node("Sprite2D").animation = "right_open"
	if name.contains("Big") && (direction == "right" || direction == "left"):
		get_node("StaticBody2D").get_node("CollisionShape2D").disabled = true
	elif name.contains("Big") && (direction == "up" || direction == "down"):
		get_node("StaticBody2D2").get_node("CollisionShape2D").disabled = true

func _physics_process(delta):
	if isNearTreasure:
		if Input.is_action_just_pressed("action_juggle_attack"):
			opened = true
	pass

func process_item_data(body):
	var treasureItem
	match treasureType:
		"key":
			treasureItem = invController.new_key_item_add(iName, description)
			print()
		"weapon":
			treasureItem = invController.new_weapon_add(iName, description, light, heavy, juggle)
			print()
	body.itemToReceive = treasureItem
	body.itemTypeToReceive = treasureType
	pass

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter") && !opened:
		isNearTreasure = true
		body.isNearInteractable = true
		process_item_data(body)
		print("press a on controller. press d on keyboard.")
	elif opened:
		print("already opened")
	pass # Replace with function body.

func _on_area_2d_body_exited(body):
	if body.name.contains("PlayerCharacter"):
		isNearTreasure = false
		body.isNearInteractable = false
		body.itemToReceive = null
	pass # Replace with function body.
