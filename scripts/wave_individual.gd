class_name WaveIndividual extends Node2D

@export var enemy_clusters : Dictionary[PackedScene, EnemyClusterDetails]


func start_wave() -> void:
	for cluster in enemy_clusters:
		var cluster_origin : Vector2 = enemy_clusters[cluster].position
		for enemy in enemy_clusters[cluster].count:
			var enemy_scene : Enemy = cluster.instantiate()
			add_child(enemy_scene)
			print("added an enemy!")
			enemy_scene.position = cluster_origin + Vector2(randf_range(-1, 1), randf_range(-1, 1))
		await get_tree().create_timer(enemy_clusters[cluster].duration).timeout
