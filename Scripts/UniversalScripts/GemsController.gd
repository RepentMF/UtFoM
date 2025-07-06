extends Node2D

var rng = RandomNumberGenerator.new()

var isSapphireEnabled = false
var isKyaniteEnabled = false
var isTanzaniteEnabled = false
var isMorganiteEnabled = false
var isKunziteEnabled = false
var isAmetrineEnabled = false
var isTopazEnabled = false
var isSunstoneEnabled = false
var isSeleniteEnabled = false
var isGosheniteEnabled = false
var isMoonstoneEnabled = false
var isPearlEnabled = false
var isOpalEnabled = false
var isAmmoliteEnabled = false
var isJetEnabled = false
var isNuummiteEnabled = false
var isObsidianEnabled = false

func ready():
	rng.randomize()

func gem_function_checker(attack):
	# if the player is the one attacking
	if attack.userName.contains("PlayerCharacter"):
		if isSapphireEnabled && attack.hitstunTimer == 0 && !attack.knockUp:
			attack.statusName = "bleed"
			attack.statusTimer = 100
			attack.statusFreq = 5
			attack.statusChange = -5
		if isKyaniteEnabled && attack.knockUp:
			attack.speed *= 1.25
		if isTanzaniteEnabled && attack.hitstunTimer > 0:
			attack.hitstunTimer *= 1.1
		if isPearlEnabled:
			if rng.randi() % 4 == 0:
				attack.manaDamage = abs(attack.manaCost)
		if isOpalEnabled:
			if rng.randi() % 4 == 0:
				attack.statusName = "execute"
				attack.statusTimer = 0
				attack.statusFreq = 0
				attack.statusChange = -5
		if isJetEnabled:
			attack.statusName = "imbibe"
			attack.statusTimer = 0
			attack.statusFreq = 0
			attack.statusChange = -5
		if isNuummiteEnabled:
			attack.statusName = "leech"
			attack.statusTimer = 100
			attack.statusFreq = 5
			attack.statusChange = -5
		if isObsidianEnabled:
			attack.statusName = "posion"
			attack.statusTimer = 100
			attack.statusFreq = 5
			attack.statusChange = -5
	# if the player is the one being attacked
	else:
		if isMorganiteEnabled:
			attack.hitstunTimer = 0
			attack.speed = 0
			attack.knockUp = false
			attack.knockUpPower = 0
			attack.baseDamage *= 3
		if isSunstoneEnabled:
			attack.manaDamage += (attack.baseDamage / 2)
			attack.baseDamage /= 2
		if isAmmoliteEnabled:
			if rng.randi() % 4 == 0:
				attack.baseDamage = 0
