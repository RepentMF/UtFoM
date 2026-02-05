extends RayCast2D


func _ready() -> void:
	var facing = get_parent().direction
	target_position = facing * 100
	print("Laser")

func _physics_process(_delta: float):
	force_raycast_update()
	target_position = to_local(get_collision_point())
	$Line2D.points[1] = target_position
	if is_colliding():
		var laserPoint = get_collision_point()
	queue_free()
