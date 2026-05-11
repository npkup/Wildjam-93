class_name Bullet extends Area2D

const SPEED : int = 1000


func _physics_process(delta: float) -> void:
	global_position.x += cos(rotation) * delta * SPEED
	global_position.y += sin(rotation) * delta * SPEED

func _ready() -> void:
	await  get_tree().create_timer(5).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(10, global_rotation_degrees)
