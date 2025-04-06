extends Node2D

var bulletMeta
var bullet

var incrementTimerDefault = 300
var incrementTimer = incrementTimerDefault

func _ready():
	bulletMeta = get_parent().get_meta("Bullet")
	bullet = load(bulletMeta)

func _physics_process(_delta):
	if incrementTimer <= 0:
		incrementTimer = incrementTimerDefault
		add_child(bullet.instantiate())
	else:
		incrementTimer -= 1
