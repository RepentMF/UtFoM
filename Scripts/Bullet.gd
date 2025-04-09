extends RigidBody2D

var shot = false
var hitstunTimer = 0
var direction = Vector2(0, 0)
var speed = 0
var height = "grounded"
var knockUp = false
var knockUpPower = 0

func _physics_process(_delta):
	if shot:
		hitstunTimer = get_meta("HitstunTimer")
		speed = get_meta("Speed")
		knockUp = get_meta("KnockUp")
		knockUpPower = get_meta("KnockUpPower")
		
		linear_velocity = direction * speed

func _on_area_body_entered(body):
	if body is CharacterBody2D:
		if height_check(body.height):
			if !body.invincible:
				body.hitstunTimer = hitstunTimer
				body.hitstunDirection = direction
				body.KBSpeed = speed
				body.currentState = body.state.hitstun
				if knockUp:
					body.juggleSpeed = knockUpPower
					body.currentState = body.state.juggle
			else:
				print("invincible!?")
			queue_free()
	pass # Replace with function body.

func height_check(bodyHeight):
	if bodyHeight == "grounded":
		if height == "grounded" || height == "aerial":
			return true
		else:
			return false
	if bodyHeight == "low":
		if height == "low" || height == "mid":
			return true
		else:
			return false
	elif bodyHeight == "mid":
		if height == "mid" || height == "aerial":
			return true
		else:
			return false
	elif bodyHeight == "aerial":
		if height == "aerial":
			return true
		else:
			return false

func _on_area_area_entered(area):
	if area is Area2D && area.name.contains("Turret") && !shot:
		shot = true
		var rotation = snapped(area.rotation, 0.0001)
		height = area.height
		if height == "aerial":
			z_index = 8
		elif height == "mid":
			z_index = 7
		elif height == "low":
			z_index = 6
		else:
			z_index = 5
		if rotation == 0:
			direction = Vector2(1, 0)
		elif rotation == snapped(PI / 2, 0.0001):
			direction = Vector2(0, 1)
		elif rotation == snapped(PI, 0.0001):
			direction = Vector2(-1, 0)
		elif rotation == snapped(-1 * PI / 2, 0.0001):
			direction = Vector2(0, -1)
	pass # Replace with function body.
