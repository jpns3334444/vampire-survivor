extends CharacterBody2D

signal health_depleted
signal level_up(new_level)

var health = 100.0
var player_level = 1
var current_xp = 0
@export var move_speed: float = 500.0
@export var max_health: float = 100.0
@export var xp_multiplier: float = 1.0

func _ready():
	%Mayor.play("idle")
	add_to_group("player")

func _physics_process(delta):

	var direction = Input.get_vector("move_left","move_right","move_up", "move_down")
	velocity = direction * move_speed
	move_and_slide()
	
	# Flip sprite when moving left/right
	if velocity.x != 0:
		$Mayor.flip_h = velocity.x < 0

	# Pick animation
	if velocity.length() > 0:
		if $Mayor.animation != "walk":
			$Mayor.play("walk")
	else:
		if $Mayor.animation != "idle":
			$Mayor.play("idle")
		
	const DAMAGE_RATE = 5
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= overlapping_mobs.size() * DAMAGE_RATE * delta
		%HPBar.value = health
		if health <= 0:
			health_depleted.emit()


func add_xp(amount: int):
	var XPBar = get_tree().get_root().get_node("Game/CanvasLayer/XPBar")
	current_xp += amount * xp_multiplier
	while current_xp >= XPBar.max_value:
		player_level += 1
		level_up.emit(player_level)
		current_xp = current_xp - XPBar.max_value
		XPBar.max_value = player_level * player_level * 2
	XPBar.value = current_xp
