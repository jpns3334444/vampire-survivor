extends CharacterBody2D

signal mob_death

@export var mob_xp: int = 1.0
@export var health: int = 10.0
@export var move_speed: int = 200
var last_direction = "down"

@onready var player = $/root/Game/Player
var last_dir := "down"

func _ready():
	%BlueRobot.play("idle_down")
	
func _physics_process(delta: float) -> void:
	# simple chase AI
	var dir := global_position.direction_to(player.global_position)  # normalized
	velocity = dir * move_speed
	move_and_slide()

	var new_animation = ""
	
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				new_animation = "walk_right"
				last_direction = "right"
			else:
				new_animation = "walk_left"
				last_direction = "left"
		else:
			if velocity.y > 0:
				new_animation = "walk_down"
				last_direction = "down"
			else:
				new_animation = "walk_up"
				last_direction = "up"
	else:
		# Use the last direction for idle animation
		new_animation = "idle_" + last_direction
	
	# Only play if it's a different animation
	if %BlueRobot.animation != new_animation:
		%BlueRobot.play(new_animation)
		
func take_damage():
	health -= 1

	if health == 0:
		var players = get_tree().get_nodes_in_group("player")
		players[0].add_xp(mob_xp)

		queue_free()
		const SMOKE_SCENE = preload("res://assets/smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.position = global_position
		mob_death.emit(mob_xp)
