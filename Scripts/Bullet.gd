extends RigidBody2D

var shot = false
var hitstunTimer = 0
var direction = Vector2(0, 0)
var speed = 0
var knockUp = false
var knockUpTimer = 0
var knockUpPower = 0

func _physics_process(_delta):
	if shot:
		hitstunTimer = get_meta("HitstunTimer")
		speed = get_meta("Speed")
		
		linear_velocity = direction * speed
		print(direction, speed)
		shot = false

func _on_area_body_entered(body):
	if body is CharacterBody2D:
		body.currentState = body.state.hitstun
		body.hitstunTimer = hitstunTimer
		body.hitstunDirection = direction
		body.groundedKBSpeed = speed
		if knockUp:
			body.knockUpTimer = knockUpTimer
			body.knockUpPower = knockUpPower
		queue_free()
	elif body is RigidBody2D && body.name.contains("Turret") && !shot:
		shot = true
		var rotation = snapped(body.rotation, 0.0001)
		if rotation == 0:
			direction = Vector2(1, 0)
		elif rotation == snapped(PI / 2, 0.0001):
			direction = Vector2(0, -1)
		elif rotation == snapped(PI, 0.0001):
			direction = Vector2(-1, 0)
		elif rotation == snapped(-1 * PI / 2, 0.0001):
			direction = Vector2(0, 1)
	pass # Replace with function body.
