extends Area2D

const SPEED_VECTOR : Vector2 = Vector2(-150, 0)
var moving : bool = false
var velocity : Vector2 = Vector2.ZERO
var player : Player
var shop_interactable : bool = false
var ship_escape_interactable : bool = false
var shopkeeper_interactable : bool = false

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
		await get_tree().create_timer(0.1).timeout
		$Node._start_waves()


func _on_body_exited(_body: Node2D) -> void:
	pass#if body is Player:
		#body.set_collision_layer_value(Global.get_collision_layer_by_name("Main"), true)
		#body.set_collision_layer_value(Global.get_collision_layer_by_name("Ship"), false)
		#body.set_collision_mask_value(Global.get_collision_layer_by_name("Main"), true)
		#body.set_collision_mask_value(Global.get_collision_layer_by_name("Ship"), false)

func _physics_process(delta: float) -> void:
	$shoparea/Panel.visible = shop_interactable
	$shipescapearea/Panel2.visible = ship_escape_interactable
	$shopkeeper/Panel3.visible = shopkeeper_interactable
	if moving:
		velocity.x = move_toward(velocity.x, SPEED_VECTOR.x, delta * 3)
		velocity.y = move_toward(velocity.y, SPEED_VECTOR.y, delta * 3)
		global_position += velocity * delta
		player.global_position += velocity * delta
	
	if shop_interactable and Input.is_action_just_pressed("interact"):
		$CanvasLayer/Control/AnimationPlayer.play("roomtransition")
		await get_tree().create_timer(0.2).timeout
		player.global_position = $StaticBody2D/shoplocation.global_position
	
	if ship_escape_interactable and Input.is_action_just_pressed("interact"):
		$CanvasLayer/Control/AnimationPlayer.play("roomtransition")
		await get_tree().create_timer(0.2).timeout
		player.global_position = $StaticBody2D/shipmainlocation.global_position
		$Node.can_proceed_to_next_wave = true
	
	if shopkeeper_interactable and Input.is_action_just_pressed("interact"):
		player.player_enabled = false
		if !$Shop.visible:
			$Shop/Shop/AnimationPlayer.play("shopmenu")
		else:
			$Shop/Shop/AnimationPlayer.play_backwards("shopmenu")
			player.player_enabled = true

func _on_shoparea_body_entered(body: Node2D) -> void:
	if body is Player:# and !$Node.wave_running:
		shop_interactable = true

func _on_shoparea_body_exited(body: Node2D) -> void:
	if body is Player:
		shop_interactable = false


func _on_shipescapearea_body_entered(body: Node2D) -> void:
	if body is Player:
		ship_escape_interactable = true


func _on_shipescapearea_body_exited(body: Node2D) -> void:
	if body is Player:
		ship_escape_interactable = false


func _on_shopkeeper_body_entered(body: Node2D) -> void:
	if body is Player:
		shopkeeper_interactable = true


func _on_shopkeeper_body_exited(body: Node2D) -> void:
	if body is Player:
		shopkeeper_interactable = false
