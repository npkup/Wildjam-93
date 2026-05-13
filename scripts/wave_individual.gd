class_name WaveIndividual extends Node2D

@export var enemy_clusters : Array[WaveItem]
@export var max_wave_duration : float

var wave_timer_function : Callable = func():
	await get_tree().create_timer(max_wave_duration).timeout
	wave_ended.emit()

signal wave_ended

func _ready() -> void:
	wave_ended.connect(queue_free)
	

func start_wave() -> void:
	wave_timer_function.call()
	for cluster in enemy_clusters:
		var cluster_origin : Vector2 = cluster.cluster_details.position
		for enemy in cluster.cluster_details.count:
			var enemy_scene : Enemy = cluster.enemy_scene.instantiate()
			add_child(enemy_scene)
			enemy_scene.position = cluster_origin + Vector2(randf_range(-10, 10), randf_range(-10, 10))
		await get_tree().create_timer(cluster.cluster_details.duration).timeout
