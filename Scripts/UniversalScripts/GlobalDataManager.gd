extends Node2D

var framesActive = 0
var start = true
var loadingFromPrev = false
var nextPlayerPosition = Vector2(0, 0)

# Player values
var inventory
var currentWeaponIndex
var attackLight
var attackHeavy
var attackJuggle
var attackBurst
var attackRoll
var attack
var height
var direction
var gravity
var isExhausted
var walkSpeed
var rollSpeed
var dashSpeed
var jumpSpeed
var runSpeed
var maxHealth
var maxMana
var maxStamina
var currentHealth
var currentMana
var currentStamina
var statusList = []
var actions
var stats
var healAmount
var dashStaminaCost
var burstManaCost
var canBunnyHop
var isDashEnabled
var isJumpEnabled
var isBurstUnlocked
var isDazeUnlocked
var isSparkActive
var isLaserActive
var isFrostActive
var isStormActive
var isAquamarineEnabled
var isCinnabarEnabled
var isAmetrineEnabled
var isCitrineEnabled
var isTopazEnabled
var isHemimorphiteEnabled
var isRhodoniteEnabled
var isRubyEnabled
var isTurquoiseEnabled
var isSeleniteEnabled
var isGosheniteEnabled
var isMoonStoneEnabled
var isPearlEnabled

func _physics_process(delta):
	if loadingFromPrev && !start:
		loadingFromPrev = false
	
	if framesActive == 0:
		framesActive += 1
	else:
		start = false

func save_player_data(body, nextScenePosition):
	inventory = body.inventory.inventory
	currentWeaponIndex = body.inventory.inventory.find(body.currentWeapon)
	
	attackLight = body.attackLight
	attackHeavy = body.attackHeavy
	attackJuggle = body.attackJuggle
	attackBurst = body.attackBurst
	attackRoll = body.attackRoll
	attack = body.attack
	height = "grounded"
	direction = body.direction
	gravity = body.gravity
	isExhausted = body.isExhausted
	
	walkSpeed = body.walkSpeed
	rollSpeed = body.rollSpeed
	dashSpeed = body.dashSpeed
	jumpSpeed = body.jumpSpeed
	runSpeed = body.runSpeed
	
	maxHealth = body.stats.maxHealth
	maxMana = body.stats.maxMana
	maxStamina = body.stats.maxStamina
	currentHealth = body.stats.currentHealth
	currentMana = body.stats.currentMana
	currentStamina = body.stats.currentStamina
	
	statusList = body.statusController.statusList
	actions = body.statusController.actions
	stats = body.statusController.stats
	
	healAmount = body.healAmount
	dashStaminaCost = body.dashStaminaCost
	burstManaCost = body.burstManaCost
	canBunnyHop = body.canBunnyHop
	isDashEnabled = body.isDashEnabled
	isJumpEnabled = body.isJumpEnabled
	isBurstUnlocked = body.isBurstUnlocked
	isDazeUnlocked = body.isDazeUnlocked
	isSparkActive = body.isSparkActive
	isLaserActive = body.isLaserActive
	isFrostActive = body.isFrostActive
	isStormActive = body.isStormActive
	
	isAquamarineEnabled = body.isAquamarineEnabled
	isCinnabarEnabled = body.isCinnabarEnabled
	isAmetrineEnabled = body.isAmetrineEnabled
	isCitrineEnabled = body.isCitrineEnabled
	isTopazEnabled = body.isTopazEnabled
	isHemimorphiteEnabled = body.isHemimorphiteEnabled
	isRhodoniteEnabled = body.isRhodoniteEnabled
	isRubyEnabled = body.isRubyEnabled
	isTurquoiseEnabled = body.isTurquoiseEnabled
	isSeleniteEnabled = body.isSeleniteEnabled
	isGosheniteEnabled = body.isGosheniteEnabled
	isMoonStoneEnabled = body.isMoonStoneEnabled
	isPearlEnabled = body.isPearlEnabled
	nextPlayerPosition = nextScenePosition

func load_player_data():
	var player = get_tree().current_scene.get_node("PlayerCharacter")
	
	get_tree().current_scene.get_node("InventoryController").inventory = inventory
	get_tree().current_scene.get_node("InventoryController").currentWeapon = inventory[currentWeaponIndex]
	
	player.currentWeapon = inventory[currentWeaponIndex]
	player.attackLight = attackLight
	player.attackHeavy = attackHeavy
	player.attackJuggle = attackJuggle
	player.attackBurst = attackBurst
	player.attackRoll = attackRoll
	player.attack = attack
	player.height = "grounded"
	player.direction = direction
	player.gravity = gravity
	player.isExhausted = isExhausted
	
	player.walkSpeed = walkSpeed
	player.rollSpeed = rollSpeed
	player.dashSpeed = dashSpeed
	player.jumpSpeed = jumpSpeed
	player.runSpeed = runSpeed
	
	player.stats.maxHealth = maxHealth
	player.stats.maxMana = maxMana
	player.stats.maxStamina = maxStamina
	player.stats.currentHealth = currentHealth
	player.stats.currentMana = currentMana
	player.stats.currentStamina = currentStamina
	
	player.statusController.statusList = statusList
	player.statusController.actions = actions
	player.statusController.stats = stats
	
	player.healAmount = healAmount
	player.dashStaminaCost = dashStaminaCost
	player.burstManaCost = burstManaCost
	player.canBunnyHop = canBunnyHop
	player.isDashEnabled = isDashEnabled
	player.isJumpEnabled = isJumpEnabled
	player.isBurstUnlocked = isBurstUnlocked
	player.isDazeUnlocked = isDazeUnlocked
	player.isSparkActive = isSparkActive
	player.isLaserActive = isLaserActive
	player.isFrostActive = isFrostActive
	player.isStormActive = isStormActive
	
	player.isAquamarineEnabled = isAquamarineEnabled
	player.isCinnabarEnabled = isCinnabarEnabled
	player.isAmetrineEnabled = isAmetrineEnabled
	player.isCitrineEnabled = isCitrineEnabled
	player.isTopazEnabled = isTopazEnabled
	player.isHemimorphiteEnabled = isHemimorphiteEnabled
	player.isRhodoniteEnabled = isRhodoniteEnabled
	player.isRubyEnabled = isRubyEnabled
	player.isTurquoiseEnabled = isTurquoiseEnabled
	player.isSeleniteEnabled = isSeleniteEnabled
	player.isGosheniteEnabled = isGosheniteEnabled
	player.isMoonStoneEnabled = isMoonStoneEnabled
	player.isPearlEnabled = isPearlEnabled
	player.global_position = nextPlayerPosition
