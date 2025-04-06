extends CharacterBody2D

enum state {idle, walk, run, roll, jump, push, hitstun}
var currentState
var direction = Vector2(0, 1)
var hitstunDirection = Vector2(0,0)
var temp

var moveSpeed = 0
var walkSpeed = 45
var rollSpeed = 80
var jumpSpeed = 65
var runSpeed = 65
var groundedKBSpeed = 0

var rollTimerDefault = 30
var rollTimer = rollTimerDefault
var jumpTimerDefault = 30
var jumpTimer = jumpTimerDefault
var hitstunTimerDefault = 0
var hitstunTimer = hitstunTimerDefault

func _physics_process(_delta):
	handle_states()
	%RichTextLabel.text = str(temp)

func handle_states():
	if currentState != state.roll && currentState != state.jump && currentState != state.push && currentState != state.hitstun:
		check_move()
	
	if Input.is_action_just_pressed("action_dodge") && currentState != state.roll && currentState != state.jump && currentState != state.hitstun:
		currentState = state.roll
	elif Input.is_action_just_pressed("action_jump") && currentState != state.roll && currentState != state.jump && currentState != state.hitstun:
		currentState = state.jump
	
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

func idle():
	velocity = Vector2(0, 0)

func move():
	if Input.is_action_pressed("move_left"):
		velocity.x = -moveSpeed
		direction.x = -1
	elif Input.is_action_pressed("move_right"):
		velocity.x = moveSpeed
		direction.x = 1
	else:
		velocity.x = 0
		direction.x = 0
	if Input.is_action_pressed("move_up"):
		velocity.y = -moveSpeed
		direction.y = -1
	elif Input.is_action_pressed("move_down"):
		velocity.y = moveSpeed
		direction.y = 1
	else:
		velocity.y = 0
		direction.y = 0
	
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

func jump():
	if jumpTimer <= 0:
		jumpTimer = jumpTimerDefault
		if is_direction_held():
			currentState = state.walk
		else:
			currentState = state.idle
	else:
		if is_direction_held():
			velocity = direction * jumpSpeed
			determine_diagonal(jumpSpeed)
		jumpTimer -= 1
		move_and_slide()

func hitstun():
	if hitstunTimer <= 0:
		hitstunTimer = hitstunTimerDefault
		if is_direction_held():
			currentState = state.walk
		else:
			currentState = state.idle
	else:
		velocity = hitstunDirection * groundedKBSpeed
		hitstunTimer -= 1
		move_and_slide()

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

func determine_diagonal(speed):
	if (abs(direction.x) + abs(direction.y)) > 1:
			var pyth = sqrt(2 * (speed * speed)) / 2
			velocity.x = pyth * direction.x
			velocity.y = pyth * direction.y

func collide():
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			if c.get_normal() == -1 * direction:
				c.get_collider().player = self
				c.get_collider().tempVelocity = Vector2(direction.x * moveSpeed, direction.y * moveSpeed)
				currentState = state.push
