extends Area2D

var player : Player

func _physics_process(delta: float) -> void:
	if player:
		if global_position.distance_to(player.global_position) > 8:
			global_position += global_position.direction_to(player.global_position) * 100 * delta
		else:
			Global.money += 1
			var audo : AudioStreamPlayer2D = $AudioStreamPlayer2D
			audo.reparent(get_parent())
			audo.play()
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		$AudioStreamPlayer2D.pitch_scale = randf_range(1.57, 1.63)
		
