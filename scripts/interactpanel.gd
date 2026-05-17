extends Panel

func _process(_delta: float) -> void:
	size = $Label.size + Vector2(10, 10)
	$Label.text = InputMap.action_get_events("interact")[0].as_text().trim_suffix(" - Physical")
