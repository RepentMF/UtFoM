extends CharacterBody2D

enum state {idle, walk, run, roll, dash, jump, push, hitstun, juggle, burst}
var currentState
var height = "grounded"
var direction = Vector2(0, 1)
var hitstunDirection = Vector2(0, 0)
var groundedPosition = Vector2(0, 0)
var gravity = 2
var countJuggleDistance = false
var dashEnabled = true
var invincible = false
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
var dashTimerDefault = 10
var dashTimer = dashTimerDefault
var jumpTimerDefault = 30
var jumpTimer = jumpTimerDefault
var hitstunTimerDefault = 0
var hitstunTimer = hitstunTimerDefault
var burstTimerDefault = 30
var burstTimer = burstTimerDefault
var airCount = 0
var juggleDistanceY = 0.0

func _physics_process(delta):
	handle_states()
	%RichTextLabel.text = str(temp, ", ", dashTimer)

func handle_states():
	if currentState != state.roll && currentState != state.dash && currentState != state.jump && currentState != state.push && currentState != state.hitstun && currentState != state.juggle && currentState != state.burst:
		check_move()
	
	if Input.is_action_just_pressed("action_burst"):
		currentState = state.burst
	
	if (Input.is_action_just_pressed("action_dodge") && !dashEnabled) && currentState != state.roll && currentState != state.jump && currentState != state.hitstun && currentState != state.juggle:
		currentState = state.roll
	elif Input.is_action_just_pressed("action_jump") && currentState != state.roll && currentState != state.jump && currentState != state.hitstun && currentState != state.juggle && currentState != state.burst:
		currentState = state.jump
	
	if (Input.is_action_just_pressed("action_dodge") && dashEnabled && is_direction_held()) && currentState != state.jump && currentState != state.hitstun && currentState != state.juggle:
		currentState = state.dash
	
	match currentState:
		state.idle:
			temp = "idle"
			idle()
		state.walk:
			moveSpeed = walkSpeed
			temp = "walk"
			move()
			collide()
		state.run:
			moveSpeed = runSpeed
			temp = "run"
			move()
		state.roll:
			temp = "roll"
			roll()
		state.dash:
			if dashEnabled:
				temp = "dash"
				dash()
		state.jump:
			temp = "jump"
			jump()
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
		else:
			currentState = state.idle
	else:
		velocity = direction * rollSpeed
		determine_diagonal(rollSpeed)
		rollTimer -= 1
		move_and_slide()

func dash():
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
		determine_direction()
		velocity = direction * dashSpeed
		determine_diagonal(dashSpeed)
		dashTimer -= 1
		move_and_slide()

func jump():
	if jumpTimer <= 0:
		height = "grounded"
		z_index = 5
		jumpTimer = jumpTimerDefault
		if is_direction_held():
			currentState = state.walk
		else:
			currentState = state.idle
	else:
		if height != "low":
			height = "low"
			z_index = 6
		if is_direction_held():
			velocity = direction * jumpSpeed
			determine_diagonal(jumpSpeed)
		jumpTimer -= 1
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
			replinish_movement_timers()
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

func return_to_juggle():
	airCount = 0
	hitstunTimer = hitstunTimerDefault
	hitstunDirection = Vector2(0, 0)
	KBSpeed = 0
	groundedPosition = Vector2(global_position.x, global_position.y - juggleDistanceY)
	if global_position.x == groundedPosition.x:
		juggleSpeed = 0
	invincible = false
	currentState = state.juggle

func burst():
	if burstTimer <= 0:
		burstTimer = burstTimerDefault
		invincible = false
		replinish_movement_timers()
		if !countJuggleDistance:
			if is_direction_held():
				currentState = state.walk
			else:
				currentState = state.idle
		else:
			return_to_juggle()
	else:
		if !invincible:
			invincible = true
			velocity = Vector2(0, 0)
		burstTimer -= 1

func check_move():
	if is_direction_held():
		if Input.is_action_pressed("action_run"):
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

func determine_diagonal(speed):
	if (abs(direction.x) + abs(direction.y)) > 1:
			var pyth = sqrt(2 * (speed * speed)) / 2
			velocity.x = pyth * direction.x
			velocity.y = pyth * direction.y

func replinish_movement_timers():
	rollTimer = rollTimerDefault
	dashTimer = dashTimerDefault
	jumpTimer = jumpTimerDefault

func collide():
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			if c.get_normal() == -1 * direction:
				c.get_collider().player = self
				c.get_collider().tempVelocity = Vector2(direction.x * moveSpeed, direction.y * moveSpeed)
				currentState = state.push
