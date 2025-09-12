extends Node2D

func _ready():
	$Forge.level_up.connect(_on_player_level_up)
	$Forge.health_depleted.connect(_on_health_depleted)
	%ForgeSprite.play("spawn")
	%ForgeSprite.play("idle")
	
func _on_player_level_up(_new_level):
	get_tree().paused = true  # Pause the game
	%LevelUpUI.show()
	
func _on_health_depleted() -> void:
	%GameOver.visible = true
