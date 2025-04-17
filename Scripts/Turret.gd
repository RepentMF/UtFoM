extends Area2D

var bulletMeta
var bullet

var ammo = 2
var delay = 0
var disabled = true
var incrementTimerDefault = 50
var incrementTimer
var height

func _ready():
	bulletMeta = "res://Attacks/Bullets/" + get_parent().get_meta("Bullet") + ".tscn"
	bullet = load(bulletMeta)
	
	height = get_parent().get_meta("Height")
	rotation = get_parent().get_meta("Rotation")
	delay = get_parent().get_meta("Delay")
	incrementTimer = incrementTimerDefault + delay
	if rotation == 0:
		rotation = 0
		position = Vector2(9, 0)
	elif rotation == 90:
		rotation = PI / 2
		position = Vector2(0, 9)
	elif rotation == 180:
		rotation = PI
		position = Vector2(-9, 0)
	elif rotation == 270:
		rotation = -PI / 2
		position = Vector2(0, -9)
	if height == "aerial":
		z_index = 4
	elif height == "mid":
		z_index = 3
	elif height == "low":
		z_index = 2
	else:
		z_index = 1

func _physics_process(_delta):
	if !disabled:
		if incrementTimer <= 0:
			incrementTimer = incrementTimerDefault
			#ammo -= 1
			add_child(bullet.instantiate())
		else:
			incrementTimer -= 1
