extends Area2D

const SPEED_VECTOR : Vector2 = Vector2(-150, 0)
var moving : bool = false
var velocity : Vector2 = Vector2.ZERO
var player : Player

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_collision_layer_value(Global.get_collision_layer_by_name("Main"), false)
		body.set_collision_layer_value(Global.get_collision_layer_by_name("Ship"), true)
		body.set_collision_mask_value(Global.get_collision_layer_by_name("Main"), false)
		body.set_collision_mask_value(Global.get_collision_layer_by_name("Ship"), true)
		$AudioStreamPlayer2D.play()
		$AnimatableBody2D/CollisionShape2D.set_deferred("disabled",false)
		await get_tree().create_timer(1).timeout
		player = body
		moving = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.set_collision_layer_value(Global.get_collision_layer_by_name("Main"), true)
		body.set_collision_layer_value(Global.get_collision_layer_by_name("Ship"), false)
		body.set_collision_mask_value(Global.get_collision_layer_by_name("Main"), true)
		body.set_collision_mask_value(Global.get_collision_layer_by_name("Ship"), false)

func _physics_process(delta: float) -> void:
	if moving:
		velocity.x = move_toward(velocity.x, SPEED_VECTOR.x, delta * 3)
		velocity.y = move_toward(velocity.y, SPEED_VECTOR.y, delta * 3)
		global_position += velocity * delta
		player.global_position += velocity * delta
