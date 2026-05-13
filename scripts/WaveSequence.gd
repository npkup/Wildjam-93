extends Node

@export var wave_nodes_array : Array[WaveIndividual]

var can_proceed_to_next_wave : bool = true

signal next_wave

func _start_waves() -> void:
	for wave in wave_nodes_array:
		wave.start_wave()
		await wave.wave_ended
		$CanvasLayer/Control/AnimationPlayer.play("wave_proceed_apprear")
		await next_wave
		$CanvasLayer/Control/AnimationPlayer.play_backwards("wave_proceed_apprear")


func _on_button_pressed() -> void:
	if can_proceed_to_next_wave:
		next_wave.emit()
