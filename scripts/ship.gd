extends Area2D

const SPEED_VECTOR : Vector2 = Vector2(-150, 0)
var moving : bool = false
var velocity : Vector2 = Vector2.ZERO
var player : Player
var shop_interactable : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.velocity.x = -100
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(2, true)
		$AudioStreamPlayer2D.play()
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",false)
		$CollisionShape2D.set_deferred("disabled", true)
		$Node.wave_running = true
		await get_tree().create_timer(1).timeout
		player = body
		moving = true
		await get_tree().create_timer(7).timeout
		$Node._start_waves()


func _on_body_exited(_body: Node2D) -> void:
	pass#if body is Player:
		#body.set_collision_layer_value(Global.get_collision_layer_by_name("Main"), true)
		#body.set_collision_layer_value(Global.get_collision_layer_by_name("Ship"), false)
		#body.set_collision_mask_value(Global.get_collision_layer_by_name("Main"), true)
		#body.set_collision_mask_value(Global.get_collision_layer_by_name("Ship"), false)

func _physics_process(delta: float) -> void:
	$shoparea/Panel.visible = shop_interactable
	if moving:
		velocity.x = move_toward(velocity.x, SPEED_VECTOR.x, delta * 3)
		velocity.y = move_toward(velocity.y, SPEED_VECTOR.y, delta * 3)
		global_position += velocity * delta
		player.global_position += velocity * delta

func _on_shoparea_body_entered(body: Node2D) -> void:
	if body is Player and !$Node.wave_running:
		shop_interactable = true

func _on_shoparea_body_exited(body: Node2D) -> void:
	if body is Player:
		shop_interactable = false
