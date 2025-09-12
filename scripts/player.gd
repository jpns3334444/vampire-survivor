extends Node2D

signal health_depleted
signal level_up(new_level)

var health = 100.0
var player_level = 1
var current_xp = 0

@export var max_health: float = 100.0
@export var xp_multiplier: float = 1.0
@export var damage_rate: float = 5.0

func _ready():
	#%Mayor.play("idle")
	add_to_group("player")

func _physics_process(delta):

	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= overlapping_mobs.size() * damage_rate * delta
		update_health_bar()
		if health <= 0:
			health_depleted.emit()

func update_health_bar():
	var health_tier = int(health / 10) * 10  # Rounds to nearest 10
	%HPBar.play(str(health_tier))

func add_xp(amount: int):
	var XPBar = get_tree().get_root().get_node("Game/CanvasLayer/XPBar")
	var Level = get_tree().get_root().get_node("Game/CanvasLayer/Level")
	current_xp += amount * xp_multiplier
	while current_xp >= XPBar.max_value:
		player_level += 1
		level_up.emit(player_level)
		Level.text = str(player_level)
		current_xp = current_xp - XPBar.max_value
		XPBar.max_value = player_level * player_level * 2
	XPBar.value = current_xp
