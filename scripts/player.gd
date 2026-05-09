extends CharacterBody2D

const MOVE_SPEED : int = 150
const ACCELERATION : int = 600
const DECELLERATION : int = 1200

func _physics_process(delta: float) -> void:
	var up_down_direction : float = Input.get_axis("up", "down")
	if up_down_direction:
		velocity.y = move_toward(velocity.y, MOVE_SPEED * up_down_direction, ACCELERATION * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, DECELLERATION * delta)
	
	var left_right_direction : float = Input.get_axis("left", "right")
	if left_right_direction:
		velocity.x = move_toward(velocity.x, MOVE_SPEED * left_right_direction, ACCELERATION * delta)
		$AnimatedSprite2D.flip_h = !left_right_direction > 0
	else:
		velocity.x = move_toward(velocity.x, 0, DECELLERATION * delta)
	
	if up_down_direction or left_right_direction:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	$Marker2D.look_at(get_global_mouse_position())
	if $Marker2D.global_rotation_degrees > 90 or $Marker2D.global_rotation_degrees < -90:
		$Marker2D/weapon.rotation_degrees = 180
		$Marker2D/weapon.flip_h = true
	elif !$Marker2D.global_rotation_degrees > 90 or !$Marker2D.global_rotation_degrees < -90:
		$Marker2D/weapon.rotation_degrees = 0
		$Marker2D/weapon.flip_h = false
	$Marker2D/weapon.texture = Global.items_list_textures[Global.inventory_items[Global.focused_slot]]
	
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
