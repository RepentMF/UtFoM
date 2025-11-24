extends CharacterBody2D

# Declaring and initializing all necessary permanent variables used for PlayerActionController 
var rng = RandomNumberGenerator.new()

# Game engine
enum state {idle, walk, run, roll, dash, hop, jump, light_attack, heavy_attack, juggle_attack, push, hitstun, juggle, heal, burst, lag, spark}
var currentState
var inventory
var currentWeapon
var attackLight = ""
var attackHeavy = ""
var attackJuggle = ""
var attackRoll = "BluntRoll"
var attack
var height = "grounded"
var direction = Vector2(0, 1)
var lastDirection = Vector2(0, 1)
var hitstunDirection = Vector2(0, 0)
var groundedPosition = Vector2(0, 0)
var gravity = 2
var countJuggleDistance = false
var canCombo = false
var secondAttack = false
var isAttacking = false
var isExhausted = false
var isInvincible = false
var isStationary = false
var temp
var done = false
var bulletMeta
var bullet

# Physics Speeds
var moveSpeed = 0
var walkSpeed = 45
var rollSpeed = 80
var dashSpeed = 250
var jumpSpeed = 65
var runSpeed = 65
var KBSpeed = 0
var juggleSpeed = 0

# Timer block
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
var healTimerDefault = 60
var healTimer = healTimerDefault
var burstTimerDefault = 30
var burstTimer = burstTimerDefault
var sparkTimerDefault = 15
var sparkTimer = sparkTimerDefault
var lagTimerDefault = 10
var lagTimer = lagTimerDefault
var airCount = 0
var juggleDistanceY = 0.0

# Costs
var stats
var healAmount = 3
var dashStaminaCost = -3
var burstManaCost = -5

# Gem instatiators
var canBunnyHop = false
var isDashEnabled = true
var isJumpEnabled = false
var isBurstUnlocked = true
var isAquamarineEnabled = false
var isCinnabarEnabled = false
var isAmetrineEnabled = false
var isCitrineEnabled = false
var isTopazEnabled = false
var isHemimorphiteEnabled = false
var isRhodoniteEnabled = false
var isRubyEnabled = false
var isTurquoiseEnabled = false
var isSeleniteEnabled = false
var isGosheniteEnabled = false
var isMoonStoneEnabled = false
var isPearlEnabled = false

func _physics_process(delta):
	# Bool "done" is false until "handle_setup()" is complete
	if !done:
		handle_setup()
	handle_states()
	translate_states()
	%RichTextLabel.text = str(canCombo)
	#%RichTextLabel.text = str(height, ", ", airCount, ", ", countJuggleDistance, ", ", KBSpeed, ", ", juggleDistanceY)
	#%RichTextLabel.text = str(temp, ", ", isAttacking, ", ", isStationary)
	#%RichTextLabel.text = str(stats.currentHealth, " / ", stats.maxHealth) + "\n" + str(stats.currentMana, " / ", stats.maxMana) + "\n" + str(stats.currentStamina, " / ", stats.maxStamina) + "\n" + currentWeapon.name + ", " + str(inventory.inventory.find(inventory.currentWeapon))
	#%RichTextLabel.text = str(temp, ", ", isAttacking, ", ", isStationary)
	#%RichTextLabel.text = str(stats.currentHealth, " / ", stats.maxHealth) + "\n" + str(stats.currentMana, " / ", stats.maxMana) + "\n" + str(stats.currentStamina, " / ", stats.maxStamina) + "\n" + currentWeapon.name + ", " + str(inventory.inventory.find(inventory.currentWeapon))

func handle_setup():
	# Calling needed nodes and values to be used in the rest of PlayerActionController
	stats = get_node("StatsController")
	inventory = get_tree().current_scene.get_node("InventoryController")
	currentWeapon = inventory.currentWeapon
	attackLight = currentWeapon.light
	attackHeavy = currentWeapon.heavy
	attackJuggle = currentWeapon.juggle
	rng.randomize()
	done = true

func handle_states():
	# Assessing every frame what needs to be done for proper State Machine assignment as well as
	# proper Gem assignment/usage
	
	# Selenite is a challenge Gem that causes the player to use no other weapons except "fists"
	if isSeleniteEnabled && currentWeapon.name != "fists":
		inventory.currentWeapon = inventory.inventory[0]
		currentWeapon = inventory.currentWeapon
		attackLight = currentWeapon.light
		attackHeavy = currentWeapon.heavy
		attackJuggle = currentWeapon.juggle
	# If Selenite is not enabled, the player may switch weapons without opening a menu
	elif !isSeleniteEnabled:
		if currentState != state.hop && currentState != state.jump && currentState != state.hitstun && currentState != state.juggle && currentState != state.lag:
	# Ametrine is an actualization Gem that allows the player to switch weapons mid-attack
	# The following blocks enable the player to switch weapons and makes the proper assignments
	# to variables to reflect the changes
			if ((!isAmetrineEnabled && !isAttacking) || isAmetrineEnabled):
				var index = inventory.inventory.find(inventory.currentWeapon)
				if Input.is_action_just_pressed("menu_prev_weapon"):
					if index - 1 == -1:
						index = inventory.inventory.size()
					inventory.currentWeapon = inventory.inventory[index - 1]
					currentWeapon = inventory.currentWeapon
					attackLight = currentWeapon.light
					attackHeavy = currentWeapon.heavy
					attackJuggle = currentWeapon.juggle
					print("Switched to " + currentWeapon.name + "!")
				elif Input.is_action_just_pressed("menu_next_weapon"):
					if index + 1 == inventory.inventory.size():
						index = -1
					inventory.currentWeapon = inventory.inventory[index + 1]
					currentWeapon = inventory.currentWeapon
					attackLight = currentWeapon.light
					attackHeavy = currentWeapon.heavy
					attackJuggle = currentWeapon.juggle
					print("Switched to " + currentWeapon.name + "!")
	# Check if the player is allowed to control their x/y velocity using the control stick
	# (If they are not: rolling, dashing, hopping, jumping, pushing, healing, using magic,
	# in hitstun, being juggled, or marked as stationary by a stationary attack)
	if !isStationary && currentState != state.roll && currentState != state.dash && currentState != state.hop && currentState != state.jump && currentState != state.push && currentState != state.hitstun && currentState != state.juggle && currentState != state.heal && currentState != state.burst && currentState != state.lag && currentState != state.spark:
		check_move()
	
	# Check for what action the player is doing this frame and makes the proper assignment to variables
	# in order to reflect that action choice
	# We check with a priority order- spells are checked first, then healing, then attacks, then movement abilities- 
	# whatever action the player chooses, we assign their StateMachine accordingly so long as the conditional passes true
	if Input.is_action_just_pressed("action_spell") && isBurstUnlocked:
	# Topaz is a dilemma Gem that allows the plyaer to cast spells for less mana cost at the difference
	# being dealt to their health
		if isTopazEnabled:
			if stats.check_current_stat(stats.currentMana, int(roundf(float(burstManaCost) / 2)), stats.maxMana, true) && stats.check_current_stat(stats.currentHealth, int(roundf(float(burstManaCost) / 2)), stats.maxHealth, true):
				stats.currentMana = stats.modify_stat(stats.currentMana, int(roundf(float(burstManaCost) / 2)), stats.maxMana)
				stats.currentHealth = stats.modify_stat(stats.currentHealth, int(roundf(float(burstManaCost) / 2)), stats.maxHealth)
	# Pearl is a chance Gem that returns mana spent on a spell to the player if the player successfully hits a target
				if isPearlEnabled:
					if rng.randi() % 4 == 0:
						stats.currentMana = stats.modify_stat(stats.currentMana, -int(roundf(float(burstManaCost) / 2)), stats.maxMana)
						stats.currentHealth = stats.modify_stat(stats.currentHealth, -int(roundf(float(burstManaCost) / 2)), stats.maxHealth)
				currentState = state.burst
		else:
			if stats.check_current_stat(stats.currentMana, burstManaCost, stats.maxMana, true):
				stats.currentMana = stats.modify_stat(stats.currentMana, burstManaCost, stats.maxMana)
	# Pearl is a chance Gem that returns mana spent on a spell to the player if the player successfully hits a target
				if isPearlEnabled:
					if rng.randi() % 4 == 0:
						stats.currentMana = stats.modify_stat(stats.currentMana, -burstManaCost, stats.maxMana)
				currentState = state.burst
	elif Input.is_action_just_pressed("action_heal") && !isAttacking && currentState != state.dash && currentState != state.roll && currentState != state.jump && currentState != state.burst && height == "grounded":
	# Goshenite is a challenge Gem that prevents the player from healing
		if !isGosheniteEnabled:
			currentState = state.heal
		else:
			print("cannot heal")
	elif Input.is_action_just_pressed("action_light_attack") && (!isAttacking || canCombo) && currentState != state.dash && currentState != state.roll && currentState != state.jump && currentState != state.burst && currentState != state.spark:
		if (attackLight != ""):
			currentState = state.light_attack
	elif Input.is_action_just_pressed("action_heavy_attack") && (!isAttacking || canCombo) && currentState != state.dash && currentState != state.roll && currentState != state.jump &&  currentState != state.burst && currentState != state.spark:
		if (attackHeavy != ""):
			currentState = state.heavy_attack
	elif Input.is_action_just_pressed("action_juggle_attack") && (!isAttacking || canCombo) && currentState != state.dash && currentState != state.roll && currentState != state.jump &&  currentState != state.burst && currentState != state.spark:
		if (attackJuggle  != ""):
			currentState = state.juggle_attack
	elif Input.is_action_just_pressed("action_spark"):
		currentState = state.spark
	
	if !is_player_locked():
		if !isExhausted && (Input.is_action_just_pressed("action_dodge") && !isDashEnabled):
	# Moonstone is a challenge Gem that prevents the player from using stamina
			if !isMoonStoneEnabled:
				currentState = state.roll
			else:
				print("cannot use SP")
		elif !isExhausted && Input.is_action_just_pressed("action_jump") && !isAttacking:
	# Moonstone is a challenge Gem that prevents the player from using stamina
			if !isMoonStoneEnabled:
				currentState = state.jump
				if !isJumpEnabled:
					currentState = state.hop
			else:
				print("cannot use SP")
	
	if currentState == state.walk || currentState == state.run || currentState == state.burst || currentState == state.spark:
		if !isExhausted && (Input.is_action_just_pressed("action_dodge") && isDashEnabled && is_direction_held()) && (!isAttacking || isHemimorphiteEnabled):
	# Moonstone is a challenge Gem that prevents the player from using stamina
				if !isMoonStoneEnabled:
	# Citrine is a dilemma Gem that allows the player to use less stamina per movement ability in exchange
	# for it dealing the difference to their health and mana in equal parts
					if isCitrineEnabled && stats.check_current_stat(stats.currentStamina, int(roundf(float(dashStaminaCost) / 3)), stats.maxStamina, true) && stats.check_current_stat(stats.currentHealth, int(roundf(float(dashStaminaCost) / 3)), stats.maxHealth, true) && stats.check_current_stat(stats.currentMana, int(roundf(float(dashStaminaCost) / 3)), stats.maxMana, true):
						stats.currentStamina = stats.modify_stat(stats.currentStamina, int(roundf(float(dashStaminaCost) / 3)), stats.maxStamina)
						stats.currentHealth = stats.modify_stat(stats.currentHealth, int(roundf(float(dashStaminaCost) / 3)), stats.maxHealth)
						stats.currentMana = stats.modify_stat(stats.currentMana, int(roundf(float(dashStaminaCost) / 3)), stats.maxMana)
	# Pearl is a chance Gem that returns mana spent on a spell to the player if the player successfully hits a target
						if isPearlEnabled:
							if rng.randi() % 4 == 0:
								stats.currentMana = stats.modify_stat(stats.currentMana, -int(roundf(float(dashStaminaCost) / 3)), stats.maxMana)
						currentState = state.dash
					elif !isCitrineEnabled && stats.check_current_stat(stats.currentStamina, dashStaminaCost, stats.maxStamina, true):
						stats.currentStamina = stats.modify_stat(stats.currentStamina, dashStaminaCost, stats.maxStamina)
						currentState = state.dash
				else:
					print("cannot use SP")
	# Handles Bunny Hopping- technique implemented by Rhodonite. Checks if player can bunny hop and if they pressed "jump"
	# then if "hop" is enabled and "jump" isn't, puts player back into hopping State
	if canBunnyHop && Input.is_action_just_pressed("action_jump"):
		if !isJumpEnabled:
			currentState = state.hop
		else:
			moveSpeed = 0
	
	# Hemimorphite is a dash Gem that allows the player to use light attacks while dashing
	if currentState == state.dash && isHemimorphiteEnabled && Input.is_action_just_pressed("action_light_attack"):
		light_attack()
	
	# State Machine Code Block
	match currentState:
		state.idle:
			moveSpeed = 0
			height = "grounded"
			idle()
		state.walk:
	# Rhodonite is a physical Gem that allows the player to "Bunny Hop." This is done by rolling and then
	# hopping before the roll ends
			if isRhodoniteEnabled && moveSpeed > walkSpeed && rollDirection == direction:
				moveSpeed = moveSpeed - 1
				if !canBunnyHop:
					canBunnyHop = true
			else:
				moveSpeed = walkSpeed
				if canBunnyHop:
					canBunnyHop = false
			if isStationary:
				currentState = state.idle
			else:
				move()
			collide()
		state.run:
	# Rhodonite is a physical Gem that allows the player to "Bunny Hop." This is done by rolling and then
	# hopping before the roll ends
			if isRhodoniteEnabled && moveSpeed > runSpeed && rollDirection == direction:
				moveSpeed = moveSpeed - 1
				if canBunnyHop:
					canBunnyHop = false
			else:
				moveSpeed = runSpeed
			if isStationary:
				currentState = state.idle
			else:
				move()
			collide()
		state.roll:
	# Ruby is a physical Gem that adds a hitbox to the player's roll
			if isRubyEnabled:
				roll_attack()
			roll()
		state.dash:
			if isDashEnabled:
				temp = "dash"
				dash()
		state.hop:
			hop()
		state.jump:
			if isJumpEnabled:
				if Input.is_action_just_pressed("action_heavy_attack") && isCinnabarEnabled:
					heavy_attack()
				temp = "jump"
				jump()
		state.light_attack:
			light_attack()
			if isStationary != null:
				if !isStationary:
					move()
		state.heavy_attack:
			heavy_attack()
			if isStationary != null:
				if !isStationary:
					move()
		state.juggle_attack:
			juggle_attack()
			if isStationary != null:
				if !isStationary:
					move()
		state.push:
			move()
			collide()
		state.hitstun:
			hitstun()
	# When the player is being juggled, we change their "height" and "z_index" based on how long they've
	# been in the air (their "juggleDistanceY")
		state.juggle:
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
		state.heal:
			heal()
		state.burst:
			burst() 
		state.spark:
			spark()
		state.lag:
			lag()

func translate_states():
	match currentState:
		0:
			temp = "idle"
		1:
			temp = "walk"
		2:
			temp = "run"
		3:
			temp = "roll"
		4:
			temp = "dash"
		5:
			temp = "hop"
		6:
			temp = "jump"
		7:
			temp = "light_attack"
		8:
			temp = "heavy_attack"
		9:
			temp = "juggle_attack"
		10:
			temp = "push"
		11:
			temp = "hitstun"
		12:
			temp = "juggle"
		13:
			temp = "heal"
		14:
			temp = "burst"
		15:
			temp = "lag"
		16:
			temp = "spark"

func idle():
	velocity = Vector2(0, 0)


func move():
	# Update the player's velocity x and velocity y to be in line with their directional
	# inputs
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
	# Rolling is based on a timer system and changes States accordingly 
	if rollTimer <= 0:
		rollTimer = rollTimerDefault
		if is_direction_held():
			currentState = state.walk
	# Rhodonite is a physical Gem that allows the player to "Bunny Hop." This is done by rolling and then
	# hopping before the roll ends
			if isRhodoniteEnabled:
				moveSpeed = rollSpeed * 1.3
				rollDirection = direction
		else:
			currentState = state.idle
	else:
		velocity = direction * rollSpeed
		determine_diagonal(rollSpeed)
	# Rhodonite is a physical Gem that allows the player to "Bunny Hop." This is done by rolling and then
	# hopping before the roll ends
		if isRhodoniteEnabled && velocity != direction * rollSpeed * 1.3:
			velocity = velocity * 1.3
			determine_diagonal(rollSpeed * 1.3)
		rollTimer -= 1
		move_and_slide()

func dash():
	# Dashing is based on a timer system and changes States accordingly 
	# Aquamarine has a dash length of 10 and a dash invincibility margin of x - 2
	if isAquamarineEnabled && dashInvMargin != 1:
		dashInvMargin = 1
	# Standard dashing has a dash length of 12 and a dash invincibility margin of x = 3
	elif !isAquamarineEnabled && dashInvMargin != 3:
		dashInvMargin = 3
	
	# Hemimorphite has a dash length of 10 and a dash invincibility margin of x + 2
	if isHemimorphiteEnabled && dashInvMargin != 5:
		dashInvMargin = 5
	elif !isHemimorphiteEnabled && dashInvMargin != 3:
		dashInvMargin = 3
	
	if dashTimer <= 0:
		dashTimer = dashTimerDefault
		if countJuggleDistance:
			return_to_juggle()
		else:
			check_move()
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
	# Hopping is based on a timer system and changes States and variables accordingly 
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
	# Jumping is based on a timer system and changes States and variables accordingly 
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
	# If the player is already attacking, the if block will check if they can start
	# a combo. If the player is not already attacking and can attack, the else block
	# will instantiate the attack
	if has_node(attackLight) || has_node(attackHeavy) || has_node(attackJuggle):
		start_combo(attackLight)
	elif !has_node(attackLight):
		attack = load("res://Attacks/Player/" + attackLight + ".tscn")
		add_child(attack.instantiate())

func heavy_attack():
	# If the player is already attacking, the if block will check if they can start
	# a combo. If the player is not already attacking and can attack, the else block
	# will instantiate the attack
	if has_node(attackLight) || has_node(attackHeavy) || has_node(attackJuggle):
		start_combo(attackHeavy)
	elif !has_node(attackHeavy):
		attack = load("res://Attacks/Player/" + attackHeavy + ".tscn")
		add_child(attack.instantiate())

func juggle_attack():
	# If the player is already attacking, the if block will check if they can start
	# a combo. If the player is not already attacking and can attack, the else block
	# will instantiate the attack
	if has_node(attackLight) || has_node(attackHeavy) || has_node(attackJuggle):
		start_combo(attackJuggle)
	elif !has_node(attackJuggle):
		attack = load("res://Attacks/Player/" + attackJuggle + ".tscn")
		add_child(attack.instantiate())

func roll_attack():
	attack = load("res://Attacks/Player/" + attackRoll + ".tscn")
	if has_node(attackRoll):
		return
	else:
		add_child(attack.instantiate())

func hitstun():
	# Being in hitstun is based on a timer system and changes States and variables 
	# accordingly 
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
	# Being juggled is based on a timer system and changes States and variables 
	# accordingly 
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

func heal():
	# Heacling is based on a timer system and changes States and variables accordingly 
	if healTimer <= 0:
		healTimer = healTimerDefault
		replenish_movement_timers()
		get_node("StatsController").currentHealth = get_node("StatsController").modify_stat(get_node("StatsController").currentHealth, healAmount, get_node("StatsController").maxHealth)
		if is_direction_held():
			currentState = state.walk
		else:
			currentState = state.idle
	else:
		healTimer -= 1

func burst():
	# Bursting is based on a timer system and changes States and variables accordingly 
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

func spark():
	if sparkTimer == sparkTimerDefault:
		bulletMeta = "res://Attacks/Bullets/" + get_meta("Bullet") + ".tscn"
		bullet = load(bulletMeta)
		var realBullet = bullet.instantiate()
		get_tree().root.get_children()[0].add_child(realBullet)
		realBullet.position = position
		realBullet.userName = "PlayerCharacter"
	if sparkTimer <= 0:
		sparkTimer = sparkTimerDefault
		replenish_movement_timers()
		if is_direction_held():
			currentState = state.walk
		else:
			currentState = state.idle
	else:
		sparkTimer -= 1

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
	# Actors can be hit while in the "juggle" state which sends them into hitstun
	# and we need a way for Actors to return to being juggled after "hitstun" is over.
	# This block is how we accomplish that.
	airCount = 0
	hitstunTimer = hitstunTimerDefault
	hitstunDirection = Vector2(0, 0)
	KBSpeed = 0
	groundedPosition = Vector2(global_position.x, global_position.y - juggleDistanceY)
	if global_position.x == groundedPosition.x:
		juggleSpeed = 0
	isInvincible = false
	currentState = state.juggle

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
	# Determines and holds the last direction taken from the player's inputs
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
		velocity.x = pyth * direction.x
		velocity.y = pyth * direction.y

func replenish_movement_timers():
	rollTimer = rollTimerDefault
	dashTimer = dashTimerDefault
	jumpTimer = jumpTimerDefault

func start_combo(next):
	if canCombo:
		if get_node(attackLight):
			if get_node(attackLight).allowCombo:
				get_node(attackLight).next_attack(next)
		elif get_node(attackHeavy):
			if get_node(attackHeavy).allowCombo:
				get_node(attackHeavy).next_attack(next)
		elif get_node(attackJuggle):
			if get_node(attackJuggle).allowCombo:
				get_node(attackJuggle).next_attack(next)
		currentState = state.idle

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
		check_move()
