extends Node2D

var rng = RandomNumberGenerator.new()

var isSapphireEnabled = false
var isKyaniteEnabled = false
var isTanzaniteEnabled = false
var isMorganiteEnabled = false
var isKunziteEnabled = false
var isTopazEnabled = false
var isSunstoneEnabled = false
var isPearlEnabled = false
var isOpalEnabled = true
var isAmmoliteEnabled = false
var isJetEnabled = false
var isNuummiteEnabled = false
var isObsidianEnabled = false

func ready():
	rng.randomize()

func gem_function_checker(attack):
# if the player is the one attacking
	if isSapphireEnabled && attack.hitstunTimer == 0 && !attack.knockUp:
		attack.statusName = "bleed"
		attack.statusTimer = 100
		attack.statusFreq = 5
		attack.statusChange = -5
		attack.statusList.push_front(attack.new_status_effect(attack.statusName, attack.statusChange, attack.statusTimer, attack.statusFreq))
	if isKyaniteEnabled && attack.knockUp:
		attack.knockUpPower = int(roundf(float(attack.knockUpPower) * 1.2))
		attack.hitstunTimer = int(roundf(float(attack.hitstunTimer) * 1.2))
	if isTanzaniteEnabled && attack.hitstunTimer > 0:
		attack.hitstunTimer *= int(roundf(float(attack.hitstunTimer) * 1.5))
	if isPearlEnabled:
		if rng.randi() % 4 == 0:
			attack.manaDamage = abs(attack.manaCost)
	if isOpalEnabled:
		if rng.randi() % 4 == 0:
			attack.statusName = "execute"
			attack.statusTimer = 0
			attack.statusFreq = 0
			attack.statusChange = -5
			attack.statusList.push_front(attack.new_status_effect(attack.statusName, attack.statusChange, attack.statusTimer, attack.statusFreq))
	if isJetEnabled:
		attack.statusName = "imbibe"
		attack.statusTimer = 0
		attack.statusFreq = 0
		attack.statusChange = -5
		attack.statusList.push_front(attack.new_status_effect(attack.statusName, attack.statusChange, attack.statusTimer, attack.statusFreq))
	if isNuummiteEnabled:
		attack.statusName = "leech"
		attack.statusTimer = 100
		attack.statusFreq = 5
		attack.statusChange = -5
		attack.statusList.push_front(attack.new_status_effect(attack.statusName, attack.statusChange, attack.statusTimer, attack.statusFreq))
	if isObsidianEnabled:
		attack.statusName = "posion"
		attack.statusTimer = 100
		attack.statusFreq = 5
		attack.statusChange = -5
		attack.statusList.push_front(attack.new_status_effect(attack.statusName, attack.statusChange, attack.statusTimer, attack.statusFreq))
	# if the player is the one being attacked
	else:
		if isMorganiteEnabled:
			attack.hitstunTimer = 0
			attack.speed = 0
			attack.knockUp = false
			attack.knockUpPower = 0
			attack.baseDamage *= 3
		if isSunstoneEnabled:
			attack.manaDamage = int(roundf(float(attack.baseDamage) / 2))
			attack.baseDamage = int(roundf(float(attack.baseDamage) / 2))
		if isAmmoliteEnabled:
			if rng.randi() % 4 == 0:
				attack.baseDamage = 0
