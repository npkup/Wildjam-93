extends CharacterBody2D

const MOVE_SPEED : int = 150
const ACCELERATION : int = 600
const DECELLERATION : int = 1200


@onready var weapon_sprite: Sprite2D = $Marker2D/weapon

var weapon_angle_ovveride : bool = false
var attack_cooldown_timer : float = 0

func _physics_process(delta: float) -> void:
	var up_down_direction : float = Input.get_axis("up", "down")
	var left_right_direction : float = Input.get_axis("left", "right")
	
	attack_cooldown_timer -= delta
	attack_cooldown_timer = clamp(attack_cooldown_timer, 0, INF)
	up_down_direction = Vector2(left_right_direction, up_down_direction).normalized().y
	left_right_direction = Vector2(left_right_direction, up_down_direction).normalized().x
	
	if Input.is_action_just_pressed("attack") and attack_cooldown_timer == 0:
		match Global.inventory_items[Global.focused_slot]:
			Global.items.PISTOL:
				$AnimationPlayer.play("pistol")
				attack_cooldown_timer = $AnimationPlayer.get_animation("pistol").length
	
	if up_down_direction:
		velocity.y = move_toward(velocity.y, MOVE_SPEED * up_down_direction, ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, DECELLERATION * delta)
	
	if left_right_direction:
		velocity.x = move_toward(velocity.x, MOVE_SPEED * left_right_direction, ACCELERATION * delta)
		$AnimatedSprite2D.flip_h = !left_right_direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, DECELLERATION * delta)
	
	if up_down_direction or left_right_direction:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	
	if !weapon_angle_ovveride:
		$Marker2D.look_at(get_global_mouse_position())
		if $Marker2D.global_rotation_degrees > 90 or $Marker2D.global_rotation_degrees < -90:
			weapon_sprite.rotation_degrees = 180
			weapon_sprite.flip_h = true
		elif !$Marker2D.global_rotation_degrees > 90 or !$Marker2D.global_rotation_degrees < -90:
			weapon_sprite.rotation_degrees = 0
			weapon_sprite.flip_h = false
		weapon_sprite.texture = Global.items_list_textures[Global.inventory_items[Global.focused_slot]]
	
	if Input.is_action_just_pressed("inventory1"):
		Global.focused_slot = 1
	if Input.is_action_just_pressed("inventory2"):
		Global.focused_slot = 2
	if Input.is_action_just_pressed("inventory3"):
		Global.focused_slot = 3
	if Input.is_action_just_pressed("inventory4"):
		Global.focused_slot = 4
	if Input.is_action_just_pressed("inventory5"):
		Global.focused_slot = 5
	
	move_and_slide()


func perpendicularize_sword() -> void:
	weapon_angle_ovveride = true
	if weapon_sprite.flip_h:
		weapon_sprite.rotation_degrees = -270
	else:
		weapon_sprite.rotation_degrees = 90

func unperpendicularize_sword() -> void:
	weapon_angle_ovveride = false
