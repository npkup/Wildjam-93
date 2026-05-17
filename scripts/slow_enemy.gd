extends Enemy

@export var move_speed : int = 80
@export var acceleration : int = 130

func _physics_process(delta: float) -> void:
	if enemy_movement_enabled:
		$detection_range/CollisionShape2D.disabled = false
		if player and alive:
			var direction : Vector2 = global_position.direction_to(player.global_position)
			velocity.x = move_toward(velocity.x, move_speed * direction.x, delta * acceleration)
			velocity.y = move_toward(velocity.y, move_speed * direction.y, delta * acceleration)
			frictioning = false
			animated_sprite.play("run")
			animated_sprite.flip_h = direction.x < 0
		elif alive:
			animated_sprite.play("idle")
		move_and_slide()


func _on_detection_range_body_entered(body: Node2D) -> void:
	if body is Player and enemy_movement_enabled:
		player = body
		$alertparticle.emitting = true
