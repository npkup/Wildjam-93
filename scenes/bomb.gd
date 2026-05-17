extends Area2D

var velocity : Vector2 = Vector2.ZERO
var direction_radians : float = 0
var decceleration : float = 0.99
var damage : int = 150

func _ready() -> void:
	$AnimationPlayer.play("bombastic")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	velocity *= decceleration
	global_position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(damage, randf() * 360)
