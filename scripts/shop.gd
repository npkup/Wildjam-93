extends Control

@onready var upgrade_button: Button = $Panel/UpgradeButton

var primary_upgrade_costs : Array[int] = [50, 90, 140, 200, 350]
var primary_upgrade_level : int = 0
var primary_attack_speed_increment : float = 0.3
var primary_damage_increment : float = 0.2

func _process(_delta: float) -> void:
	Global.primary_animation_speed = 1 + (primary_upgrade_level * primary_attack_speed_increment)
	Global.primary_damage_multiplier = 1 + (primary_upgrade_level * primary_damage_increment)
	$Panel/Label.text = "Press " + InputMap.action_get_events("interact")[0].as_text().trim_suffix(" - Physical")
	if primary_upgrade_level >= primary_upgrade_costs.size():
		upgrade_button.disabled = true
		upgrade_button.text = "MAX"
	else:
		upgrade_button.disabled = Global.money > primary_upgrade_costs[primary_upgrade_level]
		upgrade_button.text = "Upgrade (" + str(primary_upgrade_costs[primary_upgrade_level]) + ")"


func _on_button_pressed() -> void:
	if Global.money > primary_upgrade_costs[primary_upgrade_level] or 1==1:
		#Global.money -= primary_upgrade_costs[primary_upgrade_level]
		primary_upgrade_level += 1
