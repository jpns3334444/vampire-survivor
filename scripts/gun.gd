extends Area2D

@onready var player = get_parent()  # Assuming gun is child of player
var base_fire_rate = 0.5  # Base time between shots

func _ready():
	update_fire_rate()
	
func update_fire_rate():
	# Update timer based on player's attack speed
	$Timer.wait_time = base_fire_rate / player.attack_speed

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)

func _on_timer_timeout():
	shoot()
