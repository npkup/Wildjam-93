class_name Enemy extends CharacterBody2D

@export var health : int = 100
@export var max_health : int = 100
@export var knockback : int = 50
@export var friction : float = 100
@export var damage : int = 20
@export var damage_box_area2D : Area2D
@export var hitbox_shape : CollisionShape2D
@export var animated_sprite : AnimatedSprite2D
@export var other_visuals : Array[Node2D]
@export var coins_dropped_min : int
@export var coins_dropped_max : int

var player : Player
var alive : bool = true
var frictioning : bool = false
var enemy_movement_enabled : bool = false
var frozen : bool = true

var dmg_particle : PackedScene = preload("res://scenes/enemy_dmg_particles.tscn")
var dead_particle : PackedScene = preload("res://scenes/enemy_dead_particles.tscn")
var coin : PackedScene = preload("res://scenes/coin.tscn")

signal enemy_ready

func _ready() -> void:
	damage_box_area2D.body_entered.connect(_on_body_entered)
	hitbox_shape.reparent(self, true)
	animated_sprite.reparent(self, true)
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	alive = health > 0
	for visual in other_visuals:
		visual.hide()
	animated_sprite.hide()
	var spawn_alert : Sprite2D = Sprite2D.new()
	hitbox_shape.set_deferred("disabled", true)
	damage_box_area2D.get_child(0).set_deferred("disabled", true)
	spawn_alert.texture = preload("res://assets/sprites/particles/enemy_spawn_alert.png")
	add_child(spawn_alert)
	for i in 5:
		await get_tree().create_timer(0.1).timeout
		spawn_alert.hide()
		await get_tree().create_timer(0.1).timeout
		spawn_alert.show()
	spawn_alert.queue_free()
	enemy_movement_enabled = true
	for visual in other_visuals:
		visual.show()
	animated_sprite.show()
	damage_box_area2D.get_child(0).set_deferred("disabled", false)
	hitbox_shape.set_deferred("disabled", false)
	enemy_ready.emit()

func take_damage(damage_taken : int, impact_direction_degrees : float = 0.0) -> void:
	health -= damage_taken
	if health > 0:
		alive = true
		var particle : GPUParticles2D = dmg_particle.instantiate()
		particle.global_rotation_degrees = impact_direction_degrees
		particle.global_position = global_position + (Vector2(cos(deg_to_rad(impact_direction_degrees)) * knockback, sin(deg_to_rad(impact_direction_degrees)) * knockback)) / Vector2(2.2, 2.2)
		velocity = Vector2(cos(deg_to_rad(impact_direction_degrees)) * knockback, sin(deg_to_rad(impact_direction_degrees)) * knockback)
		add_sibling(particle)
		particle.global_rotation_degrees = impact_direction_degrees
		particle.global_position = global_position + (Vector2(cos(deg_to_rad(impact_direction_degrees)) * knockback, sin(deg_to_rad(impact_direction_degrees)) * knockback)) / Vector2(2.2, 2.2)
		var flash_tween : Tween = create_tween()
		flash_tween.set_ease(Tween.EASE_IN_OUT)
		flash_tween.tween_property(self, "modulate", Color(10, 10, 10, 1), 0.1)
		await get_tree().create_timer(0.1).timeout
		var unflash_tween : Tween = create_tween()
		unflash_tween.set_ease(Tween.EASE_IN_OUT)
		unflash_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
	elif alive:
		alive = false
		enemy_movement_enabled = false
		var scale_tween : Tween = create_tween()
		scale_tween.set_ease(Tween.EASE_IN_OUT)
		scale_tween.tween_property(self, "scale", Vector2(0, 0), 0.3)
		var dead : GPUParticles2D = dead_particle.instantiate()
		add_sibling(dead)
		dead.global_position = global_position
		dead.emitting = true
		for i in randi_range(coins_dropped_min, coins_dropped_max):
			var coins : Area2D = coin.instantiate()
			get_parent().add_sibling(coins)
			coins.global_position = global_position + Vector2(randf_range(-15, 15), randf_range(-15, 15))
		await get_tree().create_timer(dead.lifetime / dead.speed_scale).timeout
		dead.queue_free()
		queue_free()

func _physics_process(_delta: float) -> void:
	move_and_slide()
	if frozen:
		velocity = Vector2.ZERO

func _on_body_entered(body : Node2D) -> void:
	
	if body is Player and enemy_movement_enabled:
		body.health -= damage
		player = body
	if body is Enemy and enemy_movement_enabled:
		var push_dir : Vector2 = global_position.direction_to(body.global_position)
		velocity = push_dir * -30
