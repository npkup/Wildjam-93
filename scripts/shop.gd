extends Control

@onready var upgrade_button: Button = $Panel/UpgradeButton

var primary_upgrade_costs : Array[int] = [50, 90, 140, 200, 350]
var primary_upgrade_level : int = 0
var primary_attack_speed_increment : float = 0.3
var primary_damage_increment : float = 0.2

func _ready() -> void:
	load_random_weapons()

func _process(_delta: float) -> void:
	Global.primary_animation_speed = 1 + (primary_upgrade_level * primary_attack_speed_increment)
	Global.primary_damage_multiplier = 1 + (primary_upgrade_level * primary_damage_increment)
	$Panel/Label.text = "Press " + InputMap.action_get_events("interact")[0].as_text().trim_suffix(" - Physical")
	$Panel/Gunname.text = Global.item_list_names[Global.inventory_items[1]]
	$Panel/WeaponUpgrade/TextureRect.texture = Global.items_list_textures[Global.inventory_items[1]]
	if primary_upgrade_level >= primary_upgrade_costs.size():
		upgrade_button.disabled = true
		upgrade_button.text = "MAX"
	else:
		upgrade_button.disabled = Global.money < primary_upgrade_costs[primary_upgrade_level]
		upgrade_button.text = "Upgrade (" + str(primary_upgrade_costs[primary_upgrade_level]) + ")"

func hide_new_weapons_if_slots_full() -> void:
	var emptyness_found : bool = false
	for item in Global.inventory_items:
		if Global.inventory_items[item] == Global.items.EMPTY:
			emptyness_found = true
			break
	$Panel/Newweapn/invfull.visible = !emptyness_found

func load_random_weapons() -> void:
		var keys : Array = Global.items_list_textures.keys()
		keys = keys.slice(3, 6)
		keys.shuffle()
		keys = keys.slice(0, 3)
		$Panel/Newweapn/HBoxContainer/item1.icon = Global.items_list_textures[keys[0]]
		$Panel/Newweapn/labels/Button.text = str(Global.special_items_costs[keys[0]])
		$Panel/Newweapn/HBoxContainer/item2.icon = Global.items_list_textures[keys[1]]
		$Panel/Newweapn/labels/Button2.text = str(Global.special_items_costs[keys[1]])
		$Panel/Newweapn/HBoxContainer/item3.icon = Global.items_list_textures[keys[2]]
		$Panel/Newweapn/labels/Button3.text = str(Global.special_items_costs[keys[2]])
		$Panel/Newweapn/HBoxContainer/item1.disabled = Global.money < Global.special_items_costs[keys[0]]
		$Panel/Newweapn/HBoxContainer/item2.disabled = Global.money < Global.special_items_costs[keys[1]]
		$Panel/Newweapn/HBoxContainer/item3.disabled = Global.money < Global.special_items_costs[keys[2]]

func _on_button_pressed() -> void:
	if Global.money >= primary_upgrade_costs[primary_upgrade_level]:
		Global.money -= primary_upgrade_costs[primary_upgrade_level]
		primary_upgrade_level += 1


func _on_item_1_pressed() -> void:
	if Global.money >= int($Panel/Newweapn/labels/Button.text):
		Global.money -= int($Panel/Newweapn/labels/Button.text)
		$AnimationPlayer.play("puchased")
		for slot in Global.inventory_items:
			if Global.inventory_items[slot] == Global.items.EMPTY:
				Global.inventory_items[slot] = Global.items_list_textures.find_key($Panel/Newweapn/HBoxContainer/item1.icon)
				print(slot)
				break
				


func _on_item_2_pressed() -> void:
	if Global.money >= int($Panel/Newweapn/labels/Button2.text):
		Global.money -= int($Panel/Newweapn/labels/Button2.text)
		$AnimationPlayer.play("puchased")
		for slot in Global.inventory_items:
			if Global.inventory_items[slot] == Global.items.EMPTY:
				Global.inventory_items[slot] = Global.items_list_textures.find_key($Panel/Newweapn/HBoxContainer/item2.icon)
				break


func _on_item_3_pressed() -> void:
	if Global.money >= int($Panel/Newweapn/labels/Button3.text):
		Global.money -= int($Panel/Newweapn/labels/Button3.text)
		$AnimationPlayer.play("puchased")
		for slot in Global.inventory_items:
			if Global.inventory_items[slot] == Global.items.EMPTY:
				Global.inventory_items[slot] = Global.items_list_textures.find_key($Panel/Newweapn/HBoxContainer/item3.icon)
				break
