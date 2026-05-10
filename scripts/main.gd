extends Node2D

enum items {EMPTY, PISTOL, DAGGER, SWORD, SHOTGUN}

var items_list_textures : Dictionary[items, Texture2D] = {
	items.EMPTY  : preload("res://assets/sprites/items/empty/empty.png"),
	items.PISTOL : preload("res://assets/sprites/items/pistol/pistol.png"),
	items.DAGGER : preload("res://assets/sprites/items/dagger/dager.png"),
	items.SWORD : preload("res://assets/sprites/items/sword/sword.png"),
	items.SHOTGUN : preload("res://assets/sprites/items/shotgun/SHORTGUN.png")
}

var item_list_names : Dictionary[items, StringName] = {
	items.EMPTY : &"",
	items.PISTOL : &"Pistol",
	items.DAGGER : &"Dagger",
	items.SWORD : &"Sword",
	items.SHOTGUN : &"Shotgun"
}

var inventory_items : Dictionary[int, items] = {
	1 : items.EMPTY,
	2 : items.EMPTY,
	3 : items.EMPTY,
	4 : items.EMPTY,
	5 : items.EMPTY
}

var focused_slot : int = 1
var money : int = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	focused_slot = clamp(focused_slot, 1, 5)
