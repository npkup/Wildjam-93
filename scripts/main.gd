extends Node2D

enum items {EMPTY, PISTOL, DAGGER, SWORD, SHOTGUN, BOMB}#, LASERGUN, ICEGUN}

var ship_velocity : Vector2 = Vector2.ZERO

var items_list_textures : Dictionary[items, Texture2D] = {
	items.EMPTY  : preload("res://assets/sprites/items/empty/empty.png"),
	items.PISTOL : preload("res://assets/sprites/items/pistol/pistol.png"),
	items.DAGGER : preload("res://assets/sprites/items/dagger/dager.png"),
	items.SWORD : preload("res://assets/sprites/items/sword/sword.png"),
	items.SHOTGUN : preload("res://assets/sprites/items/shotgun/SHORTGUN.png"),
	items.BOMB : preload("res://assets/sprites/items/bomb/bomb_inv.png"),
	#items.LASERGUN : preload("res://assets/sprites/items/lasergun/lazergun.png"),
	#items.ICEGUN : preload("res://assets/sprites/items/icegun/icegun.png")
}

var item_list_names : Dictionary[items, StringName] = {
	items.EMPTY : &"",
	items.PISTOL : &"Pistol",
	items.DAGGER : &"Dagger",
	items.SWORD : &"Sword",
	items.SHOTGUN : &"Shotgun",
	items.BOMB : &"Bomb",
	#items.LASERGUN : &"Lasergun",
	#items.ICEGUN : &"Icegun"
}

var special_items_costs : Dictionary[items, int] = {
	items.SWORD : 250,
	items.SHOTGUN : 100,
	items.BOMB : 200,
}

var inventory_items : Dictionary[int, items] = {
	1 : items.EMPTY,
	2 : items.EMPTY,
	3 : items.EMPTY,
	4 : items.EMPTY,
	5 : items.EMPTY
}

var focused_slot : int = 1
var money : int = 0
var primary_damage_multiplier : float = 1
var primary_animation_speed : float = 2

func _process(_delta: float) -> void:
	focused_slot = clamp(focused_slot, 1, 5)


func get_collision_layer_by_name(layer_name: String) -> int:
	for i in range(1, 33):
		var setting_path = "layer_names/2d_physics/layer_" + str(i)
		if ProjectSettings.get_setting(setting_path) == layer_name:
			return i
	return -1
