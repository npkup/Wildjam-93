extends Panel

var weapons_chosen : Array[Global.items] = []
var max_choosable  : int = 4

func _process(_delta: float) -> void:
	$"../VBoxContainer/Confirm".disabled = !weapons_chosen.size() >= max_choosable
	
	if !weapons_chosen:
		for label in $"../../PanelContainer/VBoxContainer".get_children():
			label.text = ""
	
	if weapons_chosen:
		$"../../PanelContainer/VBoxContainer/Label".text = Global.item_list_names[weapons_chosen[0]]
	if weapons_chosen.size() > 1:
		$"../../PanelContainer/VBoxContainer/Label2".text = Global.item_list_names[weapons_chosen[1]]
	if weapons_chosen.size() > 2:
		$"../../PanelContainer/VBoxContainer/Label3".text = Global.item_list_names[weapons_chosen[2]]
	if weapons_chosen.size() > 3:
		$"../../PanelContainer/VBoxContainer/Label4".text = Global.item_list_names[weapons_chosen[3]]
	if weapons_chosen.size() > 4:
		$"../../PanelContainer/VBoxContainer/Label5".text = Global.item_list_names[weapons_chosen[4]]

func start_game() -> void:
	$"../AnimationPlayer".play("finish")
	await get_tree().create_timer(1).timeout
	$"../../../player".player_enabled = true
	
	for i in 5 - weapons_chosen.size():
		weapons_chosen.append(Global.items.EMPTY)
	
	Global.inventory_items[1] = weapons_chosen[0]
	Global.inventory_items[2] = weapons_chosen[1]
	Global.inventory_items[3] = weapons_chosen[2]
	Global.inventory_items[4] = weapons_chosen[3]
	Global.inventory_items[5] = weapons_chosen[4]
	$"../..".queue_free()


func _on_pistol_pressed() -> void:
	weapons_chosen.append(Global.items.PISTOL)
	$HBoxContainer/Pistol.disabled = true


func _on_dagger_pressed() -> void:
	weapons_chosen.append(Global.items.DAGGER)
	$HBoxContainer/Dagger.disabled = true


func _on_clear_pressed() -> void:
	weapons_chosen = []
	for button in $HBoxContainer.get_children():
		button.disabled = false


func _on_confirm_pressed() -> void:
	start_game()


func _on_sword_pressed() -> void:
	weapons_chosen.append(Global.items.SWORD)
	$HBoxContainer/Sword.disabled = true


func _on_shotgun_pressed() -> void:
	weapons_chosen.append(Global.items.SHOTGUN)
	$HBoxContainer/Shotgun.disabled = true
