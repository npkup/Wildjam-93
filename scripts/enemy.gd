class_name Enemy extends CharacterBody2D

@export var health : int = 100
@export var max_health : int = 100
@export var knockback : int = 50
@export var friction : float = 100
@export var damage : int = 20
@export var damage_box_area2D : Area2D
@export var hitbox_shape : CollisionShape2D
@export var animated_sprite : AnimatedSprite2D

var player : Player
var alive : bool = true

var dmg_particle : PackedScene = preload("res://scenes/enemy_dmg_particles.tscn")

func _ready() -> void:
	damage_box_area2D.body_entered.connect(_on_body_entered)
	hitbox_shape.reparent(self, true)
	animated_sprite.reparent(self, true)
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	alive = health > 0

func take_damage(damage_taken : int, impact_direction_degrees : float = 0.0) -> void:
	health -= damage_taken
	if health > 0:
		alive = true
		var particle : GPUParticles2D = dmg_particle.instantiate()
		particle.global_rotation_degrees = impact_direction_degrees
		particle.global_position = global_position + (Vector2(cos(deg_to_rad(impact_direction_degrees)) * knockback, sin(deg_to_rad(impact_direction_degrees)) * knockback)) / Vector2(2.2, 2.2)
		velocity = Vector2(cos(deg_to_rad(impact_direction_degrees)) * knockback, sin(deg_to_rad(impact_direction_degrees)) * knockback)
		add_sibling(particle)
		var flash_tween : Tween = create_tween()
		flash_tween.set_ease(Tween.EASE_IN_OUT)
		flash_tween.tween_property(self, "modulate", Color(10, 10, 10, 1), 0.1)
		await get_tree().create_timer(0.1).timeout
		var unflash_tween : Tween = create_tween()
		unflash_tween.set_ease(Tween.EASE_IN_OUT)
		unflash_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
	elif alive:
		alive = false
		var scale_tween : Tween = create_tween()
		scale_tween.set_ease(Tween.EASE_IN_OUT)
		scale_tween.tween_property(self, "scale", Vector2(0, 0), 0.3)
		await get_tree().create_timer(0.3).timeout
		queue_free()

func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.x = move_toward(velocity.x, 0.0, delta * friction)
	velocity.y = move_toward(velocity.y, 0.0, delta * friction)

func _on_body_entered(body : Node2D) -> void:
	if body is Player:
		body.health -= damage
		player = body
	if body is Enemy:
		var push_dir : Vector2 = global_position.direction_to(body.global_position)
		global_position -= push_dir * 30
