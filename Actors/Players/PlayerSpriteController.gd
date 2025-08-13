extends Sprite2D

var isActorAttacking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isActorAttacking != get_parent().isAttacking:
		isActorAttacking = get_parent().isAttacking
		if isActorAttacking:
			texture = get_parent().get_node("NoArmsPlayerSprite").texture
		else:
			texture = get_parent().get_node("ArmsPlayerSprite").texture
		pass
