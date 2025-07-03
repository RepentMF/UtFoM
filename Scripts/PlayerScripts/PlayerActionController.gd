extends CharacterBody2D

enum state {idle, walk, run, roll, dash, hop, jump, light_attack, heavy_attack, juggle_attack, push, hitstun, juggle, burst, lag}
var currentState
var attackLight = "LightKnife"
var attackHeavy = "HeavyHammer"
var attackJuggle = "JuggleHammer"
var attackRoll = "BluntRoll"
var attack
var height = "grounded"
var direction = Vector2(0, 1)
var lastDirection = Vector2(0, 1)
var hitstunDirection = Vector2(0, 0)
var groundedPosition = Vector2(0, 0)
var gravity = 2
var countJuggleDistance = false
var isAttacking = false
var isExhausted = false
var isInvincible = false
var isStationary
var temp

var moveSpeed = 0
var walkSpeed = 45
var rollSpeed = 80
var dashSpeed = 250
var jumpSpeed = 65
var runSpeed = 65
var KBSpeed = 0
var juggleSpeed = 0

var rollTimerDefault = 30
var rollTimer = rollTimerDefault
var rollDirection = Vector2(0, 0)
var dashTimerDefault = 12
var dashTimer = dashTimerDefault
var dashInvMargin = 4
var hopTimerDefault = 30
var hopTimer = hopTimerDefault
var jumpTimerDefault = 46
var jumpTimer = jumpTimerDefault
var hitstunTimerDefault = 0
var hitstunTimer = hitstunTimerDefault
var burstTimerDefault = 30
var burstTimer = burstTimerDefault
var lagTimerDefault = 10
var lagTimer = lagTimerDefault
var airCount = 0
var juggleDistanceY = 0.0

var dashStaminaCost = 3

var canBunnyHop = false
var isDashEnabled = true
var isJumpEnabled = false
var isRubyEnabled = false
var isCinnabarEnabled = false
var isRhodoniteEnabled = false
var isEmeraldEnabled = false
var isPeridotEnabled = false
var isMalachiteEnabled = false
var isSapphireEnabled = true
var isKyaniteEnabled = false
var isTanzaniteEnabled = false
var isTurquoiseEnabled = false
var isAquamarineEnabled = false
var isHemimorphiteEnabled = false
var isMorganiteEnabled = false
var isKunziteEnabled = false
var isAmetrineEnabled = false
var isCitrineEnabled = false
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

func _physics_process(delta):
	handle_states()
	#%RichTextLabel.text = temp
	#%RichTextLabel.text = str(get_node("StatsController").currentHealth, " / ", get_node("StatsController").maxHealth) + "\n" + str(get_node("StatsController").currentMana, " / ", get_node("StatsController").maxMana) + "\n" + str(get_node("StatsController").currentStamina, " / ", get_node("StatsController").maxStamina)

func handle_states():
	if !isStationary && currentState != state.roll && currentState != state.dash && currentState != state.hop && currentState != state.jump && currentState != state.push && currentState != state.hitstun && currentState != state.juggle && currentState != state.burst && currentState != state.lag:
		check_move()
	
	if Input.is_action_just_pressed("action_burst"):
		currentState = state.burst
	elif Input.is_action_just_pressed("action_light_attack") && !isAttacking && currentState != state.dash && currentState != state.roll && currentState != state.jump && currentState != state.burst:
		currentState = state.light_attack
	elif Input.is_action_just_pressed("action_heavy_attack") && !isAttacking && currentState != state.dash && currentState != state.roll && currentState != state.jump &&  currentState != state.burst:
		currentState = state.heavy_attack
	elif Input.is_action_just_pressed("action_juggle_attack") && !isAttacking && currentState != state.dash && currentState != state.roll && currentState != state.jump &&  currentState != state.burst:
		currentState = state.juggle_attack
	
	if !is_player_locked():
		if !isExhausted && (Input.is_action_just_pressed("action_dodge") && !isDashEnabled):
			currentState = state.roll
		elif !isExhausted && Input.is_action_just_pressed("action_jump") && !isAttacking:
			currentState = state.jump
			if !isJumpEnabled:
				currentState = state.hop
	
	if currentState == state.walk || currentState == state.run || currentState == state.burst:
		if !isExhausted && (Input.is_action_just_pressed("action_dodge") && isDashEnabled && is_direction_held()) && (!isAttacking || isHemimorphiteEnabled):
				if isCitrineEnabled && (dashStaminaCost / 3) <= get_node("StatsController").currentStamina && (dashStaminaCost / 3) <= get_node("StatsController").currentHealth && (dashStaminaCost / 3) <= get_node("StatsController").currentMana:
					get_node("StatsController").currentStamina -= (dashStaminaCost / 3)
					get_node("StatsController").currentHealth -= (dashStaminaCost / 3)
					get_node("StatsController").currentMana -= (dashStaminaCost / 3)
					currentState = state.dash
				elif !isCitrineEnabled && dashStaminaCost <= get_node("StatsController").currentStamina:
					get_node("StatsController").currentStamina -= dashStaminaCost
					currentState = state.dash
	if canBunnyHop && Input.is_action_just_pressed("action_jump"):
		if !isJumpEnabled:
			currentState = state.hop
		else:
			moveSpeed = 0
	
	if currentState == state.dash && isHemimorphiteEnabled && Input.is_action_just_pressed("action_light_attack"):
		light_attack()
	
	match currentState:
		state.idle:
			temp = "idle"
			moveSpeed = 0
			idle()
		state.walk:
			if isRhodoniteEnabled && moveSpeed > walkSpeed && rollDirection == direction:
				moveSpeed = moveSpeed - 1
				if !canBunnyHop:
					canBunnyHop = true
			else:
				moveSpeed = walkSpeed
				if canBunnyHop:
					canBunnyHop = false
			temp = "walk"
			move()
			collide()
		state.run:
			if isRhodoniteEnabled && moveSpeed > runSpeed && rollDirection == direction:
				moveSpeed = moveSpeed - 1
				if canBunnyHop:
					canBunnyHop = false
			else:
				moveSpeed = runSpeed
			temp = "run"
			move()
		state.roll:
			temp = "roll"
			if isRubyEnabled:
				roll_attack()
			roll()
		state.dash:
			if isDashEnabled:
				temp = "dash"
				dash()
		state.hop:
			temp = "hop"
			hop()
		state.jump:
			if isJumpEnabled:
				if Input.is_action_just_pressed("action_heavy_attack") && isCinnabarEnabled:
					heavy_attack()
				temp = "jump"
				jump()
		state.light_attack:
			temp = "light_attack"
			light_attack()
			if isStationary != null:
				if !isStationary:
					move()
		state.heavy_attack:
			temp = "heavy_attack"
			heavy_attack()
			if isStationary != null:
				if !isStationary:
					move()
		state.juggle_attack:
			temp = "juggle_attack"
			juggle_attack()
			if isStationary != null:
				if !isStationary:
					move()
		state.push:
			temp = "push"
			move()
			collide()
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
		state.burst:
			temp = "burst"
			burst()

func idle():
	velocity = Vector2(0, 0)

func move():
	if Input.is_action_pressed("move_left"):
		velocity.x = -moveSpeed
	elif Input.is_action_pressed("move_right"):
		velocity.x = moveSpeed
	else:
		velocity.x = 0
	if Input.is_action_pressed("move_up"):
		velocity.y = -moveSpeed
	elif Input.is_action_pressed("move_down"):
		velocity.y = moveSpeed
	else:
		velocity.y = 0
	determine_direction()
	
	if currentState == state.push && (!is_direction_held() || moveSpeed == 0):
		currentState = state.idle
	determine_diagonal(moveSpeed)
	move_and_slide()

func roll():
	if rollTimer <= 0:
		rollTimer = rollTimerDefault
		if is_direction_held():
			currentState = state.walk
			if isRhodoniteEnabled:
				moveSpeed = rollSpeed * 1.3
				rollDirection = direction
		else:
			currentState = state.idle
	else:
		velocity = direction * rollSpeed
		determine_diagonal(rollSpeed)
		if isRhodoniteEnabled && velocity != direction * rollSpeed * 1.3:
			velocity = velocity * 1.3
			determine_diagonal(rollSpeed * 1.3)
		rollTimer -= 1
		move_and_slide()

func dash():
	# aquamarine is dash length of 10 and dashinvmargin of x - 2
	if isAquamarineEnabled && dashInvMargin != 1:
		dashInvMargin = 1
	# standard dash length of 12 and dashinvmargin of x = 3
	elif !isAquamarineEnabled && dashInvMargin != 3:
		dashInvMargin = 3
	
	# hemimorphite is dash length of 12 and dashinvmargin of x + 2
	if isHemimorphiteEnabled && dashInvMargin != 5:
		dashInvMargin = 5
	elif !isHemimorphiteEnabled && dashInvMargin != 3:
		dashInvMargin = 3
	
	if dashTimer <= 0:
		dashTimer = dashTimerDefault
		if countJuggleDistance:
			return_to_juggle()
		else:
			if is_direction_held():
				currentState = state.walk
			else:
				currentState = state.idle
	else:
		if isTurquoiseEnabled:
			determine_direction()
		velocity = direction * dashSpeed
		determine_diagonal(dashSpeed)
		dashTimer -= 1
		move_and_slide()
	
	if dashTimer >= dashInvMargin && dashTimer < dashTimerDefault - dashInvMargin:
		if !isInvincible:
			isInvincible = true
	else:
		if isInvincible:
			isInvincible = false

func hop():
	if hopTimer <= 0:
		height = "grounded"
		z_index = 5
		hopTimer = hopTimerDefault
		if !isAttacking:
			if is_direction_held():
				currentState = state.walk
			else:
				currentState = state.idle
		else:
			currentState = state.lag
	else:
		if height != "low":
			height = "low"
			z_index = 6
		hopTimer -= 1
		move_and_slide()

func jump():
	if jumpTimer <= 0:
		height = "grounded"
		z_index = 5
		jumpTimer = jumpTimerDefault
		if !isAttacking:
			if is_direction_held():
				currentState = state.walk
			else:
				currentState = state.idle
		else:
			currentState = state.lag
	else:
		if height != "low":
			height = "low"
			z_index = 6
		if is_direction_held():
			velocity = direction * jumpSpeed
			determine_diagonal(jumpSpeed)
		jumpTimer -= 1
		move_and_slide()

func light_attack():
	attack = load("res://Attacks/Player/" + attackLight + ".tscn")
	if has_node(attackLight):
		return
	else:
		add_child(attack.instantiate())

func heavy_attack():
	attack = load("res://Attacks/Player/" + attackHeavy + ".tscn")
	if has_node(attackHeavy):
		return
	else:
		add_child(attack.instantiate())

func juggle_attack():
	attack = load("res://Attacks/Player/" + attackJuggle + ".tscn")
	if has_node(attackJuggle):
		return
	else:
		add_child(attack.instantiate())

func roll_attack():
	attack = load("res://Attacks/Player/" + attackRoll + ".tscn")
	if has_node(attackRoll):
		return
	else:
		add_child(attack.instantiate())

func hitstun():
	if hitstunTimer <= 0:
		if !countJuggleDistance:
			airCount = 0
			juggleSpeed = 0
			groundedPosition = Vector2(0, 0)
			hitstunTimer = hitstunTimerDefault
			hitstunDirection = Vector2(0, 0)
			KBSpeed = 0
			replenish_movement_timers()
			if height != "grounded":
				height = "grounded"
			if is_direction_held():
				currentState = state.walk
			else:
				currentState = state.idle
		else:
			return_to_juggle()
	else:
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
			replenish_movement_timers()
			if is_direction_held():
				currentState = state.walk
			else:
				currentState = state.idle
		else:
			if airCount == 0 && groundedPosition == Vector2(0, 0) && (height == "grounded" || height == "low"):
				groundedPosition = global_position
				countJuggleDistance = true
			if countJuggleDistance:
				juggleDistanceY = global_position.y - groundedPosition.y
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
		if is_direction_held():
			currentState = state.walk
		else:
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

func burst():
	if burstTimer <= 0:
		burstTimer = burstTimerDefault
		isInvincible = false
		replenish_movement_timers()
		if !countJuggleDistance:
			if is_direction_held():
				currentState = state.walk
			else:
				currentState = state.idle
		else:
			return_to_juggle()
	else:
		if !isInvincible:
			isInvincible = true
			velocity = Vector2(0, 0)
		burstTimer -= 1

func check_move():
	if is_direction_held():
		if Input.is_action_pressed("action_run") && !isExhausted:
			currentState = state.run
		else:
			currentState = state.walk
	else:
		currentState = state.idle

func is_direction_held():
	if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down"):
		return true
	else:
		return false

func is_player_locked():
	if currentState == state.roll || currentState == state.jump || currentState == state.light_attack || currentState == state.hitstun || currentState == state.juggle || currentState == state.burst:
		return true
	else:
		return false

func determine_direction():
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	elif Input.is_action_pressed("move_right"):
		direction.x = 1
	else:
		direction.x = 0
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	elif Input.is_action_pressed("move_down"):
		direction.y = 1
	else:
		direction.y = 0
	if direction != Vector2(0, 0):
		lastDirection = direction
	else:
		direction = lastDirection

func determine_diagonal(speed):
	if (abs(direction.x) + abs(direction.y)) > 1:
		var pyth = sqrt(2 * (speed * speed)) / 2
		#these are the lines of code that move player during attack
		velocity.x = pyth * direction.x
		velocity.y = pyth * direction.y

func replenish_movement_timers():
	rollTimer = rollTimerDefault
	dashTimer = dashTimerDefault
	jumpTimer = jumpTimerDefault

func collide():
	if get_slide_collision_count() != 0:
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				if c.get_normal() == -1 * direction:
					c.get_collider().player = self
					c.get_collider().tempVelocity = Vector2(direction.x * moveSpeed, direction.y * moveSpeed)
					currentState = state.push
	else:
		if is_direction_held():
			currentState = state.walk
		else:
			currentState = state.idle
