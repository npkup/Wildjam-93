class_name InventorySlot extends Panel

@export_range(1, 5) var slot_no : int

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	slot_no = clamp(slot_no, 1, 5)
	texture_rect.texture = Global.items_list_textures[Global.inventory_items[slot_no]]
	$Label.text = str(slot_no)
	if Global.focused_slot == slot_no:
		scale = Vector2(1.2, 1.2)
		modulate.r = 2
	else:
		scale = Vector2(1, 1)
		modulate.r = 1
