extends RigidBody2D

var player
var contactList = []
var noncontact = false
var tempVelocity = Vector2(0, 0)
var height = "grounded"

func _ready():
	if get_meta("Height") != "":
		height = get_meta("Height")
	
	if get_parent().get_script() == load("res://Scripts/Pushable.gd"):
		get_node("PhysicalHitbox").disabled = true
		noncontact = true
		z_index = %PlayerCharacter.z_index + 1

func _physics_process(_delta):
	if !noncontact:
		if player != null:
			mass = 100
			linear_velocity = tempVelocity
			if !player.is_direction_held() || player.moveSpeed == 0 || player.direction != tempVelocity.normalized() || contactList.has(tempVelocity.normalized()):
				player = null
				tempVelocity = Vector2(0, 0)
				linear_velocity = tempVelocity
		else:
			linear_velocity = Vector2(0, 0)
			tempVelocity = Vector2(0, 0)
			if get_node("PhysicalHitbox").disabled:
				get_node("PhysicalHitbox").disabled = false
		
		if get_colliding_bodies().size() > contactList.size():
			for collision in get_colliding_bodies():
				if collision is RigidBody2D && collision.get_script() == load("res://Scripts/Pushable.gd"):
					var holder = abs(global_position - collision.global_position)
					if abs(abs(holder.x) - abs(holder.y)) < 1.25 && tempVelocity == Vector2(0, 0):
						get_node("PhysicalHitbox").disabled = true
						if abs(collision.tempVelocity.normalized().y) > 0:
							if global_position.x > collision.global_position.x:
								global_position.x += .15
							else:
								global_position.x -= .15
						elif abs(collision.tempVelocity.normalized().x) > 0:
							if global_position.y > collision.global_position.y:
								global_position.y += .3
							else:
								global_position.y -= .3
					if !contactList.has(collision.linear_velocity.normalized()):
						if tempVelocity.normalized() == Vector2(0, 0):
							contactList.push_front(-1 * collision.tempVelocity.normalized())
						else:
							contactList.push_front(tempVelocity.normalized())
		elif get_colliding_bodies().size() < contactList.size():
			contactList.clear()
	else:
		global_position = get_parent().global_position - Vector2(0, 8)
