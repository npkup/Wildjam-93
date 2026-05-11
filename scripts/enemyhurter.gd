class_name EnemyHurter extends Area2D

@export var damage : int = 10
@export var impact_direction_degrees : float = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(damage, impact_direction_degrees)
