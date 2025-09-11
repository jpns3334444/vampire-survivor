extends Node2D

var counter = 0
@export_enum("slime", "goblin", "orc") var mob_type: String = "slime"
@export var num_mobs: int = 50
@export var wait_time: float = 0.3

@export var mob_scenes = {
	"slime": preload("res://scenes/mob_slime.tscn")
}

func spawn_mob(mob_type, num_mobs, wait_time):
	counter += 1
	%Timer.wait_time = wait_time
	var new_mob = mob_scenes[mob_type].instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	
	if counter >= num_mobs:
		$Timer.stop()

func _on_timer_timeout() -> void:
	spawn_mob("slime", 50,.3)
