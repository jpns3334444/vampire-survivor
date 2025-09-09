extends CharacterBody2D

signal mob_death

@export var mob_xp: int = 1.0
@export var health: int = 10.0
@export var move_speed: int = 200

@onready var player = $/root/Game/Player
var last_dir := "down"

func _ready():
	%BlueRobot.play("idle_down")
	
func _physics_process(delta: float) -> void:
	# simple chase AI
	var dir := global_position.direction_to(player.global_position)  # normalized
	velocity = dir * move_speed
	move_and_slide()

	# choose animation
	if velocity.length() > 0.1:
		var d := _four_dir_from_vector(velocity)
		if d != last_dir:
			last_dir = d
		_play("walk_" + d)
	else:
		_play("idle_" + last_dir)

func _four_dir_from_vector(v: Vector2) -> String:
	# Godot angles: 0=right, +PI/2=down
	var a := atan2(v.y, v.x)
	if a > -PI/4 and a <= PI/4:
		return "right"
	elif a > PI/4 and a <= 3*PI/4:
		return "down"
	elif a <= -PI/4 and a > -3*PI/4:
		return "up"
	else:
		return "left"
		
func _play(name: String) -> void:
	if %BlueRobot.animation != name:
		%BlueRobot.play(name)
		
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
