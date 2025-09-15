extends CharacterBody2D

var rng = RandomNumberGenerator.new()

var enemyName
var enemyAttacks
enum state {idle, walk, light_attack, heavy_attack, juggle_attack, hitstun, juggle, lag}
var currentState
var height = "grounded"
var direction = Vector2(0, 1)
var lastDirection = Vector2(0, 1)
var hitstunDirection = Vector2(0, 0)
var groundedPosition = Vector2(0, 0)
var targetDirection
var gravity = 2
var countJuggleDistance = false
var isAttacking = false
var isStationary = true
var isExhausted = false
var isInvincible = false
var temp

var stats

var encounterTarget
var encounterDistance

var walkSpeed = 15
var KBSpeed = 0
var juggleSpeed = 0

var idleTimerDefault = 60
var idleTimer = idleTimerDefault
var walkTimerDefault = 35
var walkTimer = walkTimerDefault
var hitstunTimerDefault = 0
var hitstunTimer = hitstunTimerDefault
var lagTimerDefault = 30
var lagTimer = lagTimerDefault
var airCount = 0
var juggleDistanceY = 0.0

func _ready():
	stats = get_node("StatsController")
	currentState = state.idle
	enemyName = get_meta("Name")
	enemyAttacks = get_node(enemyName + "AttacksController")

func _physics_process(delta):
	handle_states()
	#%RichTextLabel.text = temp
	#%RichTextLabel.text = str(hitstunTimer)
	#%RichTextLabel.text = str(name, ", ", z_index)
	#%RichTextLabel.text = str(temp, ", ", "\nHP: ", get_node("StatsController").currentHealth, "/", get_node("StatsController").maxHealth, "\nMP: ", get_node("StatsController").currentMana, "\nSP: ", get_node("StatsController").currentStamina)

func handle_states():
	match currentState:
		state.idle:
			temp = "idle"
			determine_direction()
			idle()
		state.walk:
			temp = "walk"
			walk()
		state.heavy_attack:
			temp = "heavy_attack"
			if enemyAttacks.heavy_attack(self, direction):
				move_and_slide()
			idleTimer = idleTimerDefault
		state.hitstun:
			temp = "hitstun"
			hitstun()
		state.juggle:
			temp = "juggle"
			juggle()
			if juggleDistanceY < 0:
				if juggleDistanceY < -26:
					height = "aerial"
					z_index = 8
				elif juggleDistanceY < -11 && juggleDistanceY >= -25:
					height = "mid"
					z_index = 7
				elif juggleDistanceY < -1.5 && juggleDistanceY >= -10:
					height = "low"
					z_index = 6
				elif juggleDistanceY >= -1.5:
					height = "grounded"
					z_index = 5
		state.lag:
			temp = "lag"
			lag()

func idle():
	rng.randomize()
	var random = rng.randi_range(0,7)
	idleTimer -= 1
	velocity = Vector2(0, 0)
	if idleTimer <= 0:
		if encounterTarget != null:
			enemyAttacks.decide_action(self, encounterDistance)
		else:
			if random == 8:
				direction = Vector2(0, 1)
			elif random == 7:
				direction = Vector2(-1, 1)
			elif random == 6:
				direction = Vector2(-1, 0)
			elif random == 5:
				direction = Vector2(-1, -1)
			elif random == 4:
				direction = Vector2(0, -1)
			elif random == 3:
				direction = Vector2(1, -1)
			elif random == 2:
				direction = Vector2(1, 0)
			elif random == 1:
				direction = Vector2(1, 1)
			lastDirection = direction
			idleTimer = idleTimerDefault
			currentState = state.walk

func walk():
	if walkTimer <= 0:
		walkTimer = walkTimerDefault
		currentState = state.idle
	else:
		if walkTimer == walkTimerDefault:
			velocity = walkSpeed * direction
		walkTimer -= 1
	move_and_slide()

func hitstun():
	if hitstunTimer <= 0:
		if !countJuggleDistance:
			airCount = 0
			juggleSpeed = 0
			groundedPosition = Vector2(0, 0)
			hitstunTimer = hitstunTimerDefault
			hitstunDirection = Vector2(0, 0)
			KBSpeed = 0
			if height != "grounded":
				height = "grounded"
			if encounterTarget != null:
				enemyAttacks.replenish_attack_timers()
			currentState = state.idle
		else:
			return_to_juggle()
	else:
		if KBSpeed != 0:
			velocity = hitstunDirection * KBSpeed
		hitstunTimer -= 1
		move_and_slide()

func juggle():
	if hitstunTimer <= 0:
		if airCount > 5 && juggleDistanceY >= 0:
			juggleSpeed = 0
			groundedPosition = Vector2(0, 0)
			hitstunTimer = hitstunTimerDefault
			hitstunDirection = Vector2(0, 0)
			KBSpeed = 0
			airCount = 0
			countJuggleDistance = false
			juggleDistanceY = 0
			currentState = state.lag
			enemyAttacks.replenish_attack_timers()
		else:
			if airCount == 0 && groundedPosition == Vector2(0, 0) && (height == "grounded" || height == "low"):
				groundedPosition = global_position
				countJuggleDistance = true
			if countJuggleDistance:
				juggleDistanceY = global_position.y - groundedPosition.y + 1.5
			airCount += 1
			juggleSpeed = juggleSpeed + gravity
			velocity = Vector2(0, juggleSpeed)
			move_and_slide()
	else:
		velocity = Vector2(0, 0)
		hitstunTimer -= 1
		move_and_slide()

func lag():
	if lagTimer <= 0:
		lagTimer = lagTimerDefault
		currentState = state.idle
	else:
		lagTimer = lagTimer - 1

func return_to_juggle():
	airCount = 0
	hitstunTimer = hitstunTimerDefault
	hitstunDirection = Vector2(0, 0)
	KBSpeed = 0
	groundedPosition = Vector2(global_position.x, global_position.y - juggleDistanceY)
	if global_position.x == groundedPosition.x:
		juggleSpeed = 0
	isInvincible = false
	currentState = state.juggle

func determine_direction():
	if encounterTarget != null:
		targetDirection = (position - encounterTarget.position).normalized()
		encounterDistance = int(position.distance_to(encounterTarget.position))
		if (targetDirection.x <= 0.3 && targetDirection.x >= -0.3) && (targetDirection.y >= -1.0 && targetDirection.y < -0.3):
			direction = Vector2(0, 1)
		elif (targetDirection.x > 0.3 && targetDirection.x <= 1.0) && (targetDirection.y >= -1.0 && targetDirection.y < -0.3):
			direction = Vector2(-1, 1)
		elif (targetDirection.x > 0.3 && targetDirection.x <= 1.0) && (targetDirection.y <= 0.3 && targetDirection.y >= -0.3):
			direction = Vector2(-1, 0)
		elif (targetDirection.x > 0.3 && targetDirection.x <= 1.0) && (targetDirection.y <= 1.0 && targetDirection.y > 0.3):
			direction = Vector2(-1, -1)
		elif (targetDirection.x <= 0.3 && targetDirection.x >= -0.3) && (targetDirection.y <= 1.0 && targetDirection.y > 0.3):
			direction = Vector2(0, -1)
		elif (targetDirection.x < -0.3 && targetDirection.x >= -1.0) && (targetDirection.y <= 1.0 && targetDirection.y > 0.3):
			direction = Vector2(1, -1)
		elif (targetDirection.x < -0.3 && targetDirection.x >= -1.0) && (targetDirection.y <= 0.3 && targetDirection.y >= -0.3):
			direction = Vector2(1, 0)
		elif (targetDirection.x < -0.3 && targetDirection.x >= -1.0) && (targetDirection.y >= -1.0 && targetDirection.y < -0.3):
			direction = Vector2(1, 1)
		if direction != Vector2(0, 0):
			lastDirection = direction
		else:
			direction = lastDirection
	else:
		targetDirection = null

func _on_area_2d_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		#grab player's location permanently
		encounterTarget = body
		determine_direction()
	pass # Replace with function body.

func _on_area_2d_body_exited(body):
	if encounterTarget != null:
		if body.name == encounterTarget.name:
			encounterTarget = null
	pass # Replace with function body.
