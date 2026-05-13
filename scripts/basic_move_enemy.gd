extends Enemy

@export var move_speed : int = 60
@export var idle_move_speed : int = 30
var idle_move_direction : float = deg_to_rad(randf_range(-360, 360))

@onready var idle_direction_changing_timer: Timer = $idle_direction_changing_timer

func _ready() -> void:
	idle_direction_changing_timer.wait_time = randf_range(0.5, 1.5)
	idle_direction_changing_timer.start() 

func _physics_process(delta: float) -> void:
	if player:
		var direction : Vector2 = global_position.direction_to(player.global_position)
		global_position += direction * Vector2(delta * move_speed, delta * move_speed)
	else:
		global_position += Vector2(idle_move_speed * cos(idle_move_direction) * delta, idle_move_speed * sin(idle_move_direction) * delta)


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
