extends CharacterBody2D

enum state {idle, hitstun, juggle}
var currentState
var height = "grounded"
var direction = Vector2(0, 1)
var hitstunDirection = Vector2(0, 0)
var groundedPosition = Vector2(0, 0)
var gravity = 2
var countJuggleDistance = false
var isExhausted = false
var isInvincible = false
var temp

var KBSpeed = 0
var juggleSpeed = 0

var hitstunTimerDefault = 0
var hitstunTimer = hitstunTimerDefault
var airCount = 0
var juggleDistanceY = 0.0

func _ready():
	currentState = state.idle

func _physics_process(delta):
	handle_states()
	%RichTextLabel.text = str(name, ", ", z_index)
	#%RichTextLabel.text = str(temp, ", ", "\nHP: ", get_node("StatsController").currentHealth, "/", get_node("StatsController").maxHealth, "\nMP: ", get_node("StatsController").currentMana, "\nSP: ", get_node("StatsController").currentStamina)

func handle_states():
	match currentState:
		state.idle:
			temp = "idle"
			idle()
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

func idle():
	velocity = Vector2(0, 0)

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
			currentState = state.idle
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
