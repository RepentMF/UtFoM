extends ShapeCast2D

func _ready() -> void:

func _physics_process(_delta: float):
	var cast_point := target_position
	force_shapecast_update()
	
	if is_colliding():
		for i in range(%ShapeCast2D.get_collision_count()):
			var last_collision_index = %ShapeCast2D.get_collision_count() - 1
			var last_collision_point =  %ShapeCast2D.get_collision_point(last_collision_index)
			cast_point = to_local(last_collision_point)
	$Line2D.points[1] = cast_point
	print(cast_point)
	
	queue_free()
