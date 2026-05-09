extends Node2D

enum items {EMPTY, PISTOL}

var items_list_textures : Dictionary[items, Texture2D] = {
	items.EMPTY  : preload("res://assets/sprites/items/pistol/empty.png"),
	items.PISTOL : preload("res://assets/sprites/items/pistol/pistol_inventory.png")
}

var inventory_items : Dictionary[int, items] = {
	1 : items.EMPTY,
	2 : items.EMPTY,
	3 : items.PISTOL,
	4 : items.EMPTY,
	5 : items.EMPTY
}

var focused_slot : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	focused_slot = clamp(focused_slot, 1, 5)
