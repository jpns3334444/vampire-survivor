extends Node2D

func _ready():
	$Player.level_up.connect(_on_player_level_up)
	$Player.health_depleted.connect(_on_health_depleted)
	
func _on_player_level_up(new_level):
	get_tree().paused = true  # Pause the game
	%LevelUpUI.show()
	
func _on_health_depleted() -> void:
	%GameOver.visible = true
