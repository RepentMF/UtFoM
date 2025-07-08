extends Node2D

var statusList = []
var attacked = false
var attackTimerDefault = -1
var attackTimer = 0
var baseDamage = 0
var manaCost = 0
var manaDamage = 0
var staminaCost = 0
var staminaDamage = 0
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
	baseDamage = get_meta("Damage")
	manaCost = get_meta("ManaCost")
	staminaCost = get_meta("StaminaCost")
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
	if statusName != "":
			statusList.push_front(new_status_effect(statusName, statusChange, statusTimer, statusFreq))

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
		user.stats.currentMana = user.stats.modify_stat(user.stats.currentMana, manaCost, user.stats.maxMana)
		if userName.contains("PlayerCharacter"):
			if user.isTopazEnabled:
				user.stats.currentMana = user.stats.modify_stat(user.stats.currentMana, -manaCost, user.stats.maxMana)
				user.stats.currentMana = user.stats.modify_stat(user.stats.currentMana, int(roundf(float(manaCost) / 2)), user.stats.maxMana)
				user.stats.currentHealth = user.stats.modify_stat(user.stats.currentHealth, int(roundf(float(manaCost) / 2)), user.stats.maxHealth)
	if body is CharacterBody2D && body.name != userName:
		if height_check(body.height):
			if !body.isInvincible:
				get_tree().current_scene.get_node("GemsController").gem_function_checker(self)
				for status in statusList:
					if !body.get_node("StatusController").statusList.is_empty():
						for ctlStatus in body.get_node("StatusController").statusList:
							if status.name == ctlStatus.name:
								if status.timerDefault > ctlStatus.timerDefault || status.change > ctlStatus.change:
									body.get_node("StatusController").statusList.push_front(status)
							else:
								body.get_node("StatusController").statusList.push_front(status)
					else:
						body.get_node("StatusController").statusList.push_front(status)
				body.hitstunTimer = hitstunTimer
				body.hitstunDirection = direction
				body.KBSpeed = speed
				body.currentState = body.state.hitstun
				if knockUp:
					body.juggleSpeed = knockUpPower
					body.currentState = body.state.juggle
				run_damage_calc(body)
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

func new_status_effect(sName, change, timer, freq):
	var NewStatus = load("res://Scripts/UniversalScripts/Status.gd")
	var status_instantiator = NewStatus.new()
	if statusName != "":
		status_instantiator.name = sName
		status_instantiator.change = change
		status_instantiator.timer = timer
		status_instantiator.freq = freq
		status_instantiator.timerDefault = timer
	return status_instantiator

func run_damage_calc(body):
	var stats = body.get_node("StatsController")
	var curHP = stats.currentHealth
	var maxHP = stats.maxHealth
	var curMP = stats.currentMana
	var maxMP = stats.maxMana
	var curSP = stats.currentStamina
	var maxSP = stats.maxStamina
	stats.currentHealth = stats.modify_stat(curHP, baseDamage, maxHP)
	stats.currentMana = stats.modify_stat(curMP, manaDamage, maxMP)
	stats.currentStamina = stats.modify_stat(curSP, staminaDamage, maxSP)
