class_name Bullet extends Area2D

const SPEED : int = 700

var lifetime : float = 5
var player : Player
var bullet_damage : float = 10

func _physics_process(delta: float) -> void:
	global_position.x += cos(rotation) * delta * SPEED
	global_position.y += sin(rotation) * delta * SPEED

func _ready() -> void:
	await  get_tree().create_timer(lifetime).timeout
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(bullet_damage, global_rotation_degrees)
		body.player = player
		queue_free()
