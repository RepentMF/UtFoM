extends Node2D

var statusList = []
var actions
var stats

func _ready():
	if get_parent().name == "PlayerCharacter":
		actions = get_parent()
	elif get_parent().get_script() == load("res://Scripts/EnemyScripts/EnemyActionController.gd"):
		actions = get_parent()
	stats = get_parent().get_node("StatsController")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if statusList.size() != 0:
		for status in statusList:
			if status.name == "leech":
				if status.timer > 0 && status.timer % status.freq == 0:
					stats.currentHealth = stats.modify_stat(stats.currentHealth, status.change, stats.maxHealth)
					# need to include healing portion of move once attacks are on enemies and players
				elif status.timer <= 0:
					statusList.erase(status)
			elif status.name == "poison":
				if status.timer == status.timerDefault:
					status.statDefault = stats.maxHealth
					stats.maxHealth = stats.modify_stat(stats.maxHealth, -stats.maxHealth / status.change, stats.maxHealth)
					stats.currentHealth = stats.check_min_max(stats.currentHealth, stats.maxHealth)
				elif status.timer <= 0:
					stats.maxHealth = status.statDefault
					statusList.erase(status)
				status.timer -= 1
			elif status.name == "bleed":
				if status.timer > 0 && (actions.currentState != actions.state.idle && actions.currentState != actions.state.walk && actions.currentState != actions.state.hitstun && actions.currentState != actions.state.juggle):
					if status.timer % status.freq == 0:
						stats.currentHealth = stats.modify_stat(stats.currentHealth, status.change, stats.maxHealth)
				elif status.timer <= 0:
					statusList.erase(status)
			elif status.name == "execute":
				var executeAmount = float((stats.maxHealth - stats.currentHealth)) / stats.maxHealth
				stats.currentHealth = stats.modify_stat(stats.currentHealth, floori(executeAmount * status.change), stats.maxHealth)
				statusList.erase(status)
			elif status.name == "exhaust":
				if status.timer > 0 && !actions.isExhausted:
					actions.isExhausted = true
					status.statDefault = actions.walkSpeed
					stats.currentStamina = 0
					actions.walkSpeed = stats.modify_stat(actions.walkSpeed, float(0.01 * status.change) * actions.walkSpeed, actions.walkSpeed)
				elif status.timer <= 0 || stats.currentStamina == stats.maxStamina:
					actions.isExhausted = false
					actions.walkSpeed = status.statDefault
					statusList.erase(status)
			if status.name == "imbibe":
				if status.timer > 0 && status.timer % status.freq == 0:
					stats.currentMana = stats.modify_stat(stats.currentMana, status.change, stats.maxMana)
					# need to include healing portion of move once attacks are on enemies and players
				elif status.timer <= 0:
					statusList.erase(status)
			status.timer -= 1
