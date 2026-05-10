extends Area2D

const SPEED : int = 1000

func _physics_process(delta: float) -> void:
	global_position.x += cos(rotation) * delta * SPEED
	global_position.y += sin(rotation) * delta * SPEED
