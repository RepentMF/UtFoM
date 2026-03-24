extends Node2D

var start = true
var loadingFromPrev = false

# Player values
var inventory
var currentWeapon
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
var stats
var statuses
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

func _ready():
	if start:
		start = false

func _physics_process(delta):
	if loadingFromPrev && !start:
		load_player_data()
		print("loaded data")
		loadingFromPrev = false

func save_player_data(body):
	inventory = body.get_node("Inventory")
	currentWeapon = body.currentWeapon
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
	stats = body.get_node("StatsController")
	statuses = body.get_node("StatusController")
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

func load_player_data():
	var player = get_tree().current_scene.get_node("PlayerCharacter")
	player.inventory = inventory 
	player.currentWeapon = currentWeapon
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
	player.stats = stats
	player.statusController = statuses
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
