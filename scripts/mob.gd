extends CharacterBody2D

signal mob_death

@export var mob_xp: int = 1.0
@export var health: int = 10.0
@export var move_speed: int = 200
var last_direction = "down"

@onready var forge = $/root/Game/Forge
var last_dir := "down"

func _ready():
	%AnimatedSprite2D.play("walk_right")
	
func _physics_process(delta: float) -> void:
	# simple chase AI
	var dir := global_position.direction_to(forge.global_position)  # normalized
	velocity = dir * move_speed
	move_and_slide()

	var new_animation = ""
	
	if velocity.length() > 0:
		if velocity.x > 0:
			%AnimatedSprite2D.flip_h = false   # facing right
		else:
			%AnimatedSprite2D.flip_h = true    # facing left
		
func take_damage():
	health -= 1

	if health == 0:
		var players = get_tree().get_nodes_in_group("player")
		players[0].add_xp(mob_xp)
		%AnimatedSprite2D.play("death")
		# Connect to the "animation_finished" signal
		%AnimatedSprite2D.animation_finished.connect(_on_death_animation_finished, CONNECT_ONE_SHOT)
		mob_death.emit(mob_xp)

func _on_death_animation_finished():
	queue_free()
