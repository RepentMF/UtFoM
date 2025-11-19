extends Node2D

var animation_tree

var offset
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
var allowCombo = false
var firstAttack = true

func _ready():
	if get_meta("Offset") != 0:
		offset = get_meta("Offset")
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
	if userName == "PlayerCharacter":
		animation_tree = get_node("AnimationTree")
	if statusName != "":
		statusList.push_front(new_status_effect(statusName, statusChange, statusTimer, statusFreq))

func _physics_process(_delta):
	if user == null:
		user = get_tree().root.get_node("TestArea/" + userName)
	attacked = true
	height = user.height
	if height == "aerial":
		z_index = 7
	elif height == "mid":
		z_index = 6
	elif height == "low":
		z_index = 5
	else:
		z_index = 4
	direction = user.lastDirection
	determine_direction()
	user.isAttacking = true
	user.isStationary = get_meta("isStationary")
	if firstAttack && animation_tree != null:
		animation_tree["parameters/playback"].travel(name.to_lower() + "_tree")
		animation_tree.set("parameters/" + name.to_lower() + "_tree/blend_position", direction)
		firstAttack = false
	user.stats.currentMana = user.stats.modify_stat(user.stats.currentMana, manaCost, user.stats.maxMana)
	if userName.contains("PlayerCharacter"):
		if user.isTopazEnabled:
			user.stats.currentMana = user.stats.modify_stat(user.stats.currentMana, -manaCost, user.stats.maxMana)
			user.stats.currentMana = user.stats.modify_stat(user.stats.currentMana, int(roundf(float(manaCost) / 2)), user.stats.maxMana)
			user.stats.currentHealth = user.stats.modify_stat(user.stats.currentHealth, int(roundf(float(manaCost) / 2)), user.stats.maxHealth)
	if attackTimerDefault != 0:
		attackTimer -= 1
		if attackTimer <= 0:
			user.isAttacking = false
			queue_free()
	if user != null:
		if user.currentState == user.state.hitstun || user.currentState == user.state.juggle:
			user.isAttacking = false
			if visible:
				visible = false
				user.isStationary = null
				get_node("Area/PhysicalHitbox").disabled = true
				queue_free()

func _on_area_body_entered(body):
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
		if userName != "PlayerCharacter":
			rotation = snapped(PI / 2, 0.0001)
			global_position.x = user.global_position.x + 8
			if offset != null:
				global_position.x = global_position.x - offset
			global_position.y = user.global_position.y
	elif direction == Vector2(0, 1):
		if userName != "PlayerCharacter":
			rotation = 0
			global_position.x = user.global_position.x
			global_position.y = user.global_position.y + 8
			if offset != null:
				global_position.y = global_position.y - offset
	elif direction == Vector2(-1, 0):
		if userName != "PlayerCharacter":
			rotation = snapped(-1 * PI / 2, 0.0001)
			global_position.x = user.global_position.x - 8
			if offset != null:
				global_position.x = global_position.x + offset
			global_position.y = user.global_position.y
	elif direction == Vector2(0, -1):
		if userName != "PlayerCharacter":
			rotation = snapped(PI, 0.0001)
			global_position.x = user.global_position.x
			global_position.y = user.global_position.y - 8
			if offset != null:
				global_position.y = global_position.y + offset
	elif direction == Vector2(1, 1):
		if userName != "PlayerCharacter":
			rotation = snapped(-1 * PI / 4, 0.0001)
			global_position.x = user.global_position.x + 4
			global_position.y = user.global_position.y + 4
			if offset != null:
				global_position -= Vector2(offset, offset)
	elif direction == Vector2(1, -1):
		if userName != "PlayerCharacter":
			rotation = snapped(PI / 4, 0.0001)
			global_position.x = user.global_position.x + 4
			global_position.y = user.global_position.y - 4
			if offset != null:
				global_position += Vector2(-offset, offset)
	elif direction == Vector2(-1, -1):
		if userName != "PlayerCharacter":
			rotation = snapped(-1 * PI / 4, 0.0001)
			global_position.x = user.global_position.x - 4
			global_position.y = user.global_position.y - 4
			if offset != null:
				global_position += Vector2(offset, offset)
	elif direction == Vector2(-1, 1):
		if userName != "PlayerCharacter":
			rotation = snapped(PI / 4, 0.0001)
			global_position.x = user.global_position.x - 4
			global_position.y = user.global_position.y + 4
			if offset != null:
				global_position += Vector2(offset, -offset)
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

func reset_combo():
	allowCombo = false
	user.canCombo = false
	print("here")
	pass

func can_cancel():
	allowCombo = true
	user.canCombo = true
	pass

func next_attack(next):
	if next != name:
		user.attack = load("res://Attacks/Player/" + next + ".tscn")
		user.add_child(user.attack.instantiate())
		user.canCombo = false
		user.isStationary = false
		user.secondAttack = false
		queue_free()
	elif next == name:
		if !user.secondAttack:
			animation_tree["parameters/playback"].travel(next.to_lower() + "_2_tree")
			animation_tree.set("parameters/" + next.to_lower() + "_2_tree/blend_position", direction)
			user.secondAttack = true
		else:
			animation_tree["parameters/playback"].travel(next.to_lower() + "_3_tree")
			animation_tree.set("parameters/" + next.to_lower() + "_3_tree/blend_position", direction)

func _on_animation_finished(anim_name):
	user.isAttacking = false
	user.isStationary = false
	user.canCombo = false
	user.secondAttack = false
	queue_free()
	pass # Replace with function body.
