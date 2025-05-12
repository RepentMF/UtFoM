extends Node2D

var attacked = false
var attackTimerDefault = -1
var attackTimer = 0
var damage = 0
var user
var hitstunTimer = 0
var direction
var speed = 0
var height = "grounded"
var knockUp = false
var knockUpPower = 0
var statusName = ""
var statusTimer = 0
var statusFreq = 0
var statusChange = 0
var userName

func _ready():
	visible = false
	damage = get_meta("Damage")
	attackTimerDefault = get_meta("AttackTimer")
	attackTimer = attackTimerDefault
	hitstunTimer = get_meta("HitstunTimer")
	speed = get_meta("Speed")
	knockUp = get_meta("KnockUp")
	knockUpPower = get_meta("KnockUpPower")
	statusName = get_meta("Status")
	statusTimer = get_meta("StatusTimer")
	statusFreq = get_meta("StatusFreq")
	statusChange = get_meta("StatusChange")
	userName = get_meta("UserName")

func _physics_process(_delta):
	if attackTimerDefault == -1:
		get_node("Area/PhysicalHitbox").disabled = true
	if direction != Vector2(0, 0):
		get_node("Area/PhysicalHitbox").disabled = false
	if attacked && attackTimer > 0:
		attackTimer -= 1
	elif attackTimer <= 0 && attackTimer != -1:
		user.isAttacking = false
		if visible:
			visible = false
			user.isStationary = null
			get_node("Area/PhysicalHitbox").disabled = true
			queue_free()
	
func _on_area_body_entered(body):
	if body.name == userName:
		attacked = true
		height = body.height
		if height == "aerial":
			z_index = 7
		elif height == "mid":
			z_index = 6
		elif height == "low":
			z_index = 5
		else:
			z_index = 4
		user = body
		direction = user.lastDirection
		determine_direction()
		user.isAttacking = true
		user.isStationary = get_meta("isStationary")
	if body is CharacterBody2D && body.name != userName:
		if height_check(body.height):
			if !body.isInvincible:
				if statusName != "":
					apply_status_effect(body)
				body.hitstunTimer = hitstunTimer
				body.hitstunDirection = direction
				body.KBSpeed = speed
				body.currentState = body.state.hitstun
				if knockUp:
					body.juggleSpeed = knockUpPower
					body.currentState = body.state.juggle
				var targetStats = body.get_node("StatsController")
				targetStats.currentHealth = targetStats.modify_stat(targetStats.currentHealth, damage, targetStats.maxHealth)
	pass # Replace with function body.

func determine_direction():
	if direction == Vector2(1, 0):
		rotation = snapped(PI / 2, 0.0001)
		global_position.x = user.global_position.x + 8
		global_position.y = user.global_position.y
	elif direction == Vector2(0, 1):
		rotation = 0
		global_position.x = user.global_position.x
		global_position.y = user.global_position.y + 8
	elif direction == Vector2(-1, 0):
		rotation = snapped(-1 * PI / 2, 0.0001)
		global_position.x = user.global_position.x - 8
		global_position.y = user.global_position.y
	elif direction == Vector2(0, -1):
		rotation = snapped(PI, 0.0001)
		global_position.x = user.global_position.x
		global_position.y = user.global_position.y - 8
	elif direction == Vector2(1, 1):
		rotation = snapped(-1 * PI / 4, 0.0001)
		global_position.x = user.global_position.x + 4
		global_position.y = user.global_position.y + 4
	elif direction == Vector2(1, -1):
		rotation = snapped(PI / 4, 0.0001)
		global_position.x = user.global_position.x + 4
		global_position.y = user.global_position.y - 4
	elif direction == Vector2(-1, -1):
		rotation = snapped(-1 * PI / 4, 0.0001)
		global_position.x = user.global_position.x - 4
		global_position.y = user.global_position.y - 4
	elif direction == Vector2(-1, 1):
		rotation = snapped(PI / 4, 0.0001)
		global_position.x = user.global_position.x - 4
		global_position.y = user.global_position.y + 4
	visible = true

func height_check(bodyHeight):
	if bodyHeight == "grounded":
		if height == "grounded" || height == "aerial":
			return true
		else:
			return false
	if bodyHeight == "low":
		if height == "grounded" || height == "low" || height == "mid":
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

func apply_status_effect(body):
	var NewStatus = load("res://Scripts/Status.gd")
	var status_instantiator = NewStatus.new()
	if body.get_node("StatusController").statusList.size() != 0:
		for status in body.get_node("StatusController").statusList:
			if status.name == statusName && (status.name == "poison"):
				return
	status_instantiator.name = statusName
	status_instantiator.change = statusChange
	status_instantiator.timer = statusTimer
	status_instantiator.freq = statusFreq
	status_instantiator.timerDefault = statusTimer
	body.get_node("StatusController").statusList.push_front(status_instantiator)
