class_name Player extends CharacterBody2D

const MOVE_SPEED : int = 150
const ACCELERATION : int = 600
const DECELLERATION : int = 1200


@onready var weapon_sprite: Sprite2D = $Marker2D/Marker2D/weapon
@onready var gunshot_pistol: AudioStreamPlayer2D = $Node2D/gunshot_pistol
@onready var dagger_sound: AudioStreamPlayer2D = $Node2D/dagger

@export var perpendicular_weapon : bool = true
@export var weapon_angle_ovveride : bool = false
@export_range(0, 1) var lookahead_ratio : float = 0.3

var attack_cooldown_timer : float = 0
var weapon_target_rotation_degrees : float = 0
var camera_shake_power : int = 0
var player_enabled : bool = false
var health : int = 100:
	set(value):
		if value > health:
			$playerdmg.play("player_heal")
		else:
			$playerdmg.play("player_hurt")
			$"../Dmgflash/AnimationPlayer".play("dmg")
		
		if value <= 0:
			$playerdmg.play("death")
			player_enabled = false
			Engine.time_scale = 0.5
			$AnimatedSprite2D.stop()
			await $playerdmg.animation_finished
			$"../UI/Panel".visible = true
			await $"../UI/Panel/Button".pressed
			$"../UI/Panel".visible = false
			Engine.get_main_loop().reload_current_scene()
			Engine.time_scale = 1
		
		health = value
		$"../UI/healthbar".value = health
var max_health : int = 100

var bullet_trail : PackedScene = preload("res://scenes/bullettrail.tscn")
var pistol_bullet : PackedScene = preload("res://scenes/pistolbullet.tscn")
var bomb : PackedScene = preload("res://scenes/bomb.tscn")

func _ready() -> void:
	$"../UI/healthbar".value = health
	$"../UI/healthbar".max_value = max_health

func _physics_process(delta: float) -> void:
	%Money.text = "$" + str(Global.money)
	if player_enabled:
		$ProgressBar.value = attack_cooldown_timer
		$ProgressBar.visible = attack_cooldown_timer > 0
		$mouseframe.global_position = global_position + (get_global_mouse_position() - global_position)/(1/lookahead_ratio)
		var up_down_direction : float = Input.get_axis("up", "down")
		var left_right_direction : float = Input.get_axis("left", "right")
		weapon_sprite.rotation_degrees = lerp(weapon_sprite.rotation_degrees, weapon_target_rotation_degrees, 0.1)
		
		
		attack_cooldown_timer -= delta
		attack_cooldown_timer = clamp(attack_cooldown_timer, 0, INF)
		up_down_direction = Vector2(left_right_direction, up_down_direction).normalized().y
		left_right_direction = Vector2(left_right_direction, up_down_direction).normalized().x
		
		
		if Input.is_action_pressed("attack") and attack_cooldown_timer == 0:
			$AnimationPlayer.play("RESET")
			match Global.inventory_items[Global.focused_slot]:
				Global.items.PISTOL:
					
					$AnimationPlayer.play("pistol")
					$AnimationPlayer.speed_scale = Global.primary_animation_speed
					var bullet : Bullet = pistol_bullet.instantiate()
					bullet.bullet_damage = 10 * Global.primary_damage_multiplier
					bullet.global_rotation = $Marker2D.global_rotation
					bullet.global_position = weapon_sprite.global_position
					bullet.player = self
					add_sibling(bullet)
					gunshot_pistol.play()
					gunshot_pistol.pitch_scale = randf_range(0.96, 1.04)
					camera_shake_power = 4
					attack_cooldown_timer = $AnimationPlayer.get_animation("pistol").length / $AnimationPlayer.speed_scale
					$ProgressBar.max_value = attack_cooldown_timer
				Global.items.DAGGER:
					$AnimationPlayer.play("dagger")
					$AnimationPlayer.speed_scale = Global.primary_animation_speed
					$Marker2D/EnemyHurter.damage = 15 * Global.primary_damage_multiplier
					$Marker2D/EnemyHurter.impact_direction_degrees = $Marker2D.global_rotation_degrees
					attack_cooldown_timer = $AnimationPlayer.get_animation("pistol").length / $AnimationPlayer.speed_scale
					$ProgressBar.max_value = attack_cooldown_timer
					dagger_sound.play()
					dagger_sound.pitch_scale = randf_range(0.96, 1.04)
				Global.items.SHOTGUN:
					var bullet1 : Bullet = pistol_bullet.instantiate()
					var bullet2 : Bullet = pistol_bullet.instantiate()
					var bullet3 : Bullet = pistol_bullet.instantiate()
					bullet1.global_position = weapon_sprite.global_position
					bullet2.global_position = weapon_sprite.global_position
					bullet3.global_position = weapon_sprite.global_position
					bullet1.player = self
					bullet2.player = self
					bullet3.player = self
					bullet1.rotation_degrees = $Marker2D.rotation_degrees - 15
					add_sibling(bullet1)
					bullet2.rotation_degrees = $Marker2D.rotation_degrees
					add_sibling(bullet2)
					bullet3.rotation_degrees = $Marker2D.rotation_degrees + 15
					add_sibling(bullet3)
					$AnimationPlayer.play("shotgun")
					$Node2D/shotgun.play()
					$Node2D/shotgun.pitch_scale = randf_range(0.96, 1.04)
					velocity.x = -cos($Marker2D.rotation) * 200
					velocity.y = -sin($Marker2D.rotation) * 200
					camera_shake_power = 6
					attack_cooldown_timer = $AnimationPlayer.get_animation("shotgun").length / $AnimationPlayer.speed_scale
					$ProgressBar.max_value = attack_cooldown_timer
				Global.items.SWORD:
					$AnimationPlayer.play("sword")
					$Marker2D/EnemyHurter.damage = 60
					$Marker2D/EnemyHurter.impact_direction_degrees = $Marker2D.global_rotation_degrees
					$Node2D/sword.pitch_scale = randf_range(0.96, 1.04)
					attack_cooldown_timer = $AnimationPlayer.get_animation("sword").length / $AnimationPlayer.speed_scale
					await get_tree().create_timer(0.2).timeout
					$Node2D/sword.play()
				Global.items.BOMB:
					attack_cooldown_timer = 3.5
					$ProgressBar.max_value = attack_cooldown_timer
					var bombastic : Area2D = bomb.instantiate()
					bombastic.direction_radians = $Marker2D.rotation
					bombastic.velocity = Vector2(cos($Marker2D.rotation) * 180, sin($Marker2D.rotation) * 180)
					add_sibling(bombastic)
					bombastic.global_position = global_position
		
		
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
			if perpendicular_weapon:
				weapon_target_rotation_degrees = -270
			else:
				weapon_target_rotation_degrees = 180
			weapon_sprite.flip_h = true
			$AnimatedSprite2D.flip_h = true
		elif !$Marker2D.global_rotation_degrees > 90 or !$Marker2D.global_rotation_degrees < -90:
			if perpendicular_weapon:
				weapon_target_rotation_degrees = 90
			else:
				weapon_target_rotation_degrees = 0
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
	$mouseframe/Camera2D.offset = Vector2(randf_range(-camera_shake_power, camera_shake_power), randf_range(-camera_shake_power, camera_shake_power))
	@warning_ignore("narrowing_conversion")
	camera_shake_power = move_toward(camera_shake_power, 0, delta * 5)


func _on_animation_player_animation_finished(_anim_name : StringName) -> void:
	weapon_angle_ovveride = false
	perpendicular_weapon = false


func _on_animation_player_animation_changed(_old_name: StringName, _new_name: StringName) -> void:
	weapon_angle_ovveride = false
	perpendicular_weapon = false
