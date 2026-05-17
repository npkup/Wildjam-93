extends Node

@export var wave_nodes_array : Array[WaveIndividual]

var can_proceed_to_next_wave : bool = true
var wave_running : bool = false

signal next_wave

func _start_waves() -> void:
	for wave in wave_nodes_array:
		wave.start_wave()
		wave_running = true
		await wave.wave_ended
		wave_running = false
		$CanvasLayer/Control/AnimationPlayer.play("wave_proceed_apprear")
		await next_wave
		
		$CanvasLayer/Control/AnimationPlayer.play_backwards("wave_proceed_apprear")


func _on_button_pressed() -> void:
	if can_proceed_to_next_wave:
		wave_running = true
		next_wave.emit()
