extends Area2D

var areaSceneName
var areaNextSceneName
var load = false

func _ready():
	var index = str(get_tree().current_scene).find(":")
	areaSceneName = str(get_tree().current_scene).left(index)
	areaNextSceneName = get_meta("NextSceneName")

func _physics_process(delta):
	if load:
		get_tree().change_scene_to_file("res://Areas/" + areaNextSceneName + ".tscn")

func save_player_data(player):
	player.get_node("Inventory")
	player.currentWeapon
	player.attackLight
	player.attackHeavy
	player.attackJuggle
	player.attackBurst
	player.attackRoll = "BluntRoll"
	player.attack
	player.height = "grounded"
	player.direction = Vector2(0, 1)
	player.gravity = 2
	player.countJuggleDistance = false
	player.isExhausted = false

	# Physics Speeds
	player.moveSpeed = 0
	player.walkSpeed = 60
	player.rollSpeed = 80
	player.dashSpeed = 250
	player.jumpSpeed = 65
	player.runSpeed = 90

	# Costs
	player.get_node("StatsController")
	player.healAmount = 3
	player.dashStaminaCost = -3
	player.burstManaCost = -5

	# Gem instatiators
	player.canBunnyHop = false
	player.isDashEnabled = true
	player.isJumpEnabled = true
	player.isBurstUnlocked = false
	player.isDazeUnlocked = false
	player.isSparkActive = false
	player.isLaserActive = false
	player.isFrostActive = true
	player.isStormActive = false
	player.isAquamarineEnabled = false
	player.isCinnabarEnabled = false
	player.isAmetrineEnabled = false
	player.isCitrineEnabled = false
	player.isTopazEnabled = false
	player.isHemimorphiteEnabled = false
	player.isRhodoniteEnabled = false
	player.isRubyEnabled = false
	player.isTurquoiseEnabled = false
	player.isSeleniteEnabled = false
	player.isGosheniteEnabled = false
	player.isMoonStoneEnabled = false
	player.isPearlEnabled = false

func _on_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		print("res://Areas/" + areaNextSceneName + ".tscn")
		load = true
		save_player_data(body)
		# Save player data
	pass # Replace with function body.
