extends RigidBody2D

var shot = false
var hitstunTimer = 0
var direction = Vector2(0, 0)
var speed = 0
var height = "grounded"
var knockUp = false
var knockUpPower = 0
var baseDamage = 0
var manaCost = 0
var manaDamage = 0
var user
var statusName = ""
var statusTimer = 0
var statusFreq = 0
var statusChange = 0
var userName = ""

func _physics_process(_delta):
	if shot && linear_velocity == Vector2(0, 0):
		hitstunTimer = get_meta("HitstunTimer")
		speed = get_meta("Speed")
		knockUp = get_meta("KnockUp")
		knockUpPower = get_meta("KnockUpPower")
		statusName = get_meta("Status")
		statusTimer = get_meta("StatusTimer")
		statusFreq = get_meta("StatusFreq")
		statusChange = get_meta("StatusChange")
		baseDamage = get_meta("Damage")
		userName = get_meta("UserName")
		linear_velocity = direction * speed

func _on_area_body_entered(body):
	if body is CharacterBody2D:
		if height_check(body.height):
			if !body.isInvincible:
				if statusName != "":
					new_status_effect("", "", "", "")
				body.hitstunTimer = hitstunTimer
				body.hitstunDirection = direction
				body.KBSpeed = speed
				body.currentState = body.state.hitstun
				if knockUp:
					body.juggleSpeed = knockUpPower
					body.currentState = body.state.juggle
				queue_free()
	pass # Replace with function body.

func height_check(bodyHeight):
	if bodyHeight == "grounded":
		if height == "grounded":
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
			z_index = 7
		elif height == "mid":
			z_index = 6
		elif height == "low":
			z_index = 5
		else:
			z_index = 4
		if rotation == 0:
			direction = Vector2(1, 0)
		elif rotation == snapped(PI / 2, 0.0001):
			direction = Vector2(0, 1)
		elif rotation == snapped(PI, 0.0001):
			direction = Vector2(-1, 0)
		elif rotation == snapped(-1 * PI / 2, 0.0001):
			direction = Vector2(0, -1)
	pass # Replace with function body.

func new_status_effect(sName, change, timer, freq):
	var NewStatus = load("res://Scripts/UniversalScripts/Status.gd")
	var status_instantiator = NewStatus.new()
	if statusName != "":
		status_instantiator.name = statusName
		status_instantiator.change = statusChange
		status_instantiator.timer = statusTimer
		status_instantiator.freq = statusFreq
		status_instantiator.timerDefault = statusTimer
	else:
		status_instantiator.name = sName
		status_instantiator.change = change
		status_instantiator.timer = timer
		status_instantiator.freq = freq
		status_instantiator.timerDefault = timer
	return status_instantiator
