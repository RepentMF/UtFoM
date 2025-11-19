extends Node

# Enemy name: slime

var rng = RandomNumberGenerator.new()

var attackHeavy
var attack

var maxEncounterRange = 55.0
var heavyAttackTimerDefault = 30
var heavyAttackTimer = heavyAttackTimerDefault
var heavyStartupTimerDefault = 40
var heavyStartupTimer = heavyStartupTimerDefault
var heavySpeed = 30

func decide_action(body, distance):
	rng.randomize()
	var random = rng.randi()
	if distance > (maxEncounterRange / 2):
		if random % 35 == 0:
			body.currentState = body.state.heavy_attack
	elif distance < (maxEncounterRange / 2):
		if random % 10 == 0:
			body.currentState = body.state.heavy_attack
	elif body.currentState != body.state.idle:
		body.currentState = body.state.idle

func heavy_attack(body, direction):
	if heavyStartupTimer > 0:
		heavyStartupTimer -= 1
		return false
	else:
		if body.velocity == Vector2(0, 0):
			body.velocity = heavySpeed * direction
			if has_node("HeavySlimeAttack"):
				return
			else:
				attackHeavy = load("res://Attacks/Enemies/Commons/HeavySlimeAttack.tscn")
				attack = attackHeavy
				add_child(attack.instantiate())
		elif heavyAttackTimer > 0:
			heavyAttackTimer -= 1
			return true
		else:
			replenish_attack_timers()
			body.currentState = body.state.idle
			return false

func replenish_attack_timers():
	heavyAttackTimer = heavyAttackTimerDefault
	heavyStartupTimer = heavyStartupTimerDefault
