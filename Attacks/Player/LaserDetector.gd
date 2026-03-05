extends RayCast2D

var attack
var direction
var stopPosition
var laserDistance
var checkedDistance = false

func _ready() -> void:
	direction = get_parent().direction
	target_position = direction * 1000

func _physics_process(_delta: float):
	force_raycast_update()
	if checkedDistance:
		attack = load("res://Attacks/Player/JuggleLaser.tscn")
		get_parent().add_child(attack.instantiate())
		get_parent().get_node("JuggleLaser").set_meta("Size", laserDistance)
		queue_free()
	elif is_colliding():
		target_position = to_local(get_collision_point())
		$Line2D.points[1] = target_position
		stopPosition = get_collision_point()
		laserDistance = stopPosition - get_parent().global_position
		if laserDistance.y == 0:
			laserDistance = abs(snappedf(laserDistance.x, 0.1))
		else:
			laserDistance = abs(snappedf(laserDistance.y, 0.1))
		checkedDistance = true
	else:
		target_position = get_parent().global_position + (direction * 1000)
		$Line2D.points[1] = target_position
		stopPosition = target_position
		laserDistance = direction * 1000
		if laserDistance.y == 0:
			laserDistance = abs(snappedf(laserDistance.x, 0.1))
		else:
			laserDistance = abs(snappedf(laserDistance.y, 0.1))
		checkedDistance = true
