extends Node2D

@export var obstacle = preload("res://scenes/menu/particle.tscn")

func _ready():
	repeat()

func spawn():
	var spawned = obstacle.instantiate()
	add_child(spawned)

	var spawn_pos = global_position
	spawn_pos.x = spawn_pos.x + randf_range(-1000, 1000)

	spawned.global_position = spawn_pos



func repeat():
	spawn()
	await get_tree().create_timer(1)


func _on_timer_timeout():
	var spawned = obstacle.instantiate()
	spawned.x = randf_range(20, 1000)
	get_parent().add_child(spawned)

	var spawn_pos = global_position

	spawned.global_position = spawn_pos
