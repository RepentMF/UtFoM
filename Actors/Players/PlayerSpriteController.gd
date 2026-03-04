extends Sprite2D

var isActorAttacking = false
var hasActorException = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isActorAttacking != get_parent().isAttacking:
		isActorAttacking = get_parent().isAttacking
		print(isActorAttacking, ", ", hasActorException)
		if isActorAttacking && !hasActorException:
			texture = get_parent().get_node("NoArmsPlayerSprite").texture
		else:
			texture = get_parent().get_node("ArmsPlayerSprite").texture
		pass
