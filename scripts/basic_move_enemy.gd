extends Enemy

@export var move_accel : int = 300
@export var idle_move_accel : int = 150
var idle_move_direction : float = deg_to_rad(randf_range(-360, 360))

@onready var idle_direction_changing_timer: Timer = $idle_direction_changing_timer

func _physics_process(delta: float) -> void:
	if player:
		var direction : Vector2 = global_position.direction_to(player.global_position)
		velocity += direction * Vector2(delta * move_accel, delta * move_accel)
	else:
		velocity += Vector2(idle_move_accel * cos(idle_move_direction) * delta, idle_move_accel * sin(idle_move_direction) * delta)
	velocity = Vector2(move_toward(velocity.x, 0, delta * 100), move_toward(velocity.y, 0, delta * 100))
	move_and_slide()

func _on_detection_range_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		if idle_direction_changing_timer:
			$alertparticle.emitting = true
			idle_direction_changing_timer.queue_free()


func _on_idle_direction_changing_timer_timeout() -> void:
	idle_move_direction = deg_to_rad(randf_range(-360, 360))
	idle_direction_changing_timer.wait_time = randf_range(0.5, 1.5)
	idle_direction_changing_timer.start() 
