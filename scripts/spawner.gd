extends Node2D

@export var mob_scenes = {
	"slime": preload("res://scenes/mob_slime.tscn"),
	"goblin": preload("res://scenes/mob_goblin.tscn"),
	"orc": preload("res://scenes/mob_orc.tscn")
}

func spawn_mob(mob_type, num_mobs, wait_time):
	var new_mob = mob_scenes.slime.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _on_timer_timeout() -> void:
	spawn_mob
