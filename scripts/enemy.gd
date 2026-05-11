class_name Enemy extends CharacterBody2D

var health : int = 100
var max_health : int = 100

var dmg_particle : PackedScene = preload("res://scenes/enemy_dmg_particles.tscn")

func take_damage(damage : int, impact_direction_degrees : float = 0.0) -> void:
	health -= damage
	var particle : GPUParticles2D = dmg_particle.instantiate()
	particle.global_rotation_degrees = impact_direction_degrees
	particle.global_position = global_position
	add_sibling(particle)
	var flash_tween : Tween = create_tween()
	flash_tween.set_ease(Tween.EASE_IN_OUT)
	flash_tween.tween_property(self, "modulate", Color(10, 10, 10, 1), 0.1)
	await get_tree().create_timer(0.1).timeout
	var unflash_tween : Tween = create_tween()
	unflash_tween.set_ease(Tween.EASE_IN_OUT)
	unflash_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
