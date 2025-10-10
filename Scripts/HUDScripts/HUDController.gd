extends Control


func _physics_process(_delta: float) -> void:
	%HealthBar.value = %StatsController.currentHealth
