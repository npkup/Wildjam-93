extends CharacterBody2D

const MOVE_SPEED : int = 150
const ACCELERATION : int = 600
const DECELLERATION : int = 1200


@onready var weapon_sprite: Sprite2D = $Marker2D/weapon
@onready var gunshot_pistol: AudioStreamPlayer2D = $Node2D/gunshot_pistol
@onready var dagger_sound: AudioStreamPlayer2D = $Node2D/dagger


var weapon_angle_ovveride : bool = false
var attack_cooldown_timer : float = 0
var weapon_target_rotation_degrees : float = 0
var camera_shake_power : int = 0
var player_enabled : bool = false

var bullet_trail : PackedScene = preload("res://scenes/bullettrail.tscn")
var pistol_bullet : PackedScene = preload("res://scenes/pistolbullet.tscn")

func _physics_process(delta: float) -> void:
	if player_enabled:
		var up_down_direction : float = Input.get_axis("up", "down")
		var left_right_direction : float = Input.get_axis("left", "right")
		weapon_sprite.global_rotation_degrees = lerp(weapon_sprite.global_rotation_degrees, weapon_target_rotation_degrees, 0.1)
		
		$"../UI/Money".text = "$" + str(Global.money)
		attack_cooldown_timer -= delta
		attack_cooldown_timer = clamp(attack_cooldown_timer, 0, INF)
		up_down_direction = Vector2(left_right_direction, up_down_direction).normalized().y
		left_right_direction = Vector2(left_right_direction, up_down_direction).normalized().x
		
		if Input.is_action_pressed("attack") and attack_cooldown_timer == 0:
			$AnimationPlayer.stop()
			match Global.inventory_items[Global.focused_slot]:
				
				Global.items.PISTOL:
					$AnimationPlayer.play("pistol")
					var bullet : Area2D = pistol_bullet.instantiate()
					bullet.global_rotation = $Marker2D.global_rotation
					bullet.global_position = $Marker2D/weapon.global_position
					add_sibling(bullet)
					gunshot_pistol.play()
					gunshot_pistol.pitch_scale = randf_range(0.96, 1.04)
					camera_shake_power = 4
					attack_cooldown_timer = $AnimationPlayer.get_animation("pistol").length / $AnimationPlayer.speed_scale
				Global.items.DAGGER:
					$AnimationPlayer.play("dagger")
					attack_cooldown_timer = $AnimationPlayer.get_animation("pistol").length / $AnimationPlayer.speed_scale
					dagger_sound.play()
					dagger_sound.pitch_scale = randf_range(0.96, 1.04)
		
		
		if up_down_direction:
			velocity.y = move_toward(velocity.y, MOVE_SPEED * up_down_direction, ACCELERATION * delta)
		else:
			velocity.y = move_toward(velocity.y, 0, DECELLERATION * delta)
		
		if left_right_direction:
			velocity.x = move_toward(velocity.x, MOVE_SPEED * left_right_direction, ACCELERATION * delta)
			
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
				$AnimatedSprite2D.flip_h = true
			elif !$Marker2D.global_rotation_degrees > 90 or !$Marker2D.global_rotation_degrees < -90:
				weapon_sprite.rotation_degrees = 0
				weapon_sprite.flip_h = false
				$AnimatedSprite2D.flip_h = false
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

func _process(delta: float) -> void:
	$Camera2D.offset = Vector2(randf_range(-camera_shake_power, camera_shake_power), randf_range(-camera_shake_power, camera_shake_power))
	camera_shake_power = move_toward(camera_shake_power, 0, delta * 5)
