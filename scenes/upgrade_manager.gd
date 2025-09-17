extends CanvasLayer

var available_upgrades = [
	{"name": "Turret Car", "function": "add_turret_car"},
	{"name": "Shield Car", "function": "add_shield_car"},
	{"name": "Faster Train", "function": "upgrade_train_speed"}
]

var current_upgrade_options = []  # Store what each button does

func show_level_up_options():
	# Set button texts and connect signals
	var buttons = [$VBoxContainer/HBoxContainer/Option1/Button, 
				   $VBoxContainer/HBoxContainer/Option2/Button,
				   $VBoxContainer/HBoxContainer/Option3/Button]
	
	for i in range(3):
		current_upgrade_options.append(available_upgrades.pick_random())
		buttons[i].text = current_upgrade_options[i]["name"]
		
		# Disconnect any previous connections
		if buttons[i].pressed.is_connected(_on_option_pressed):
			buttons[i].pressed.disconnect(_on_option_pressed)
		
		# Connect with the button index
		buttons[i].pressed.connect(_on_option_pressed.bind(i))

func _on_option_pressed(button_index: int):
	var function_name = current_upgrade_options[button_index]["function"]
	
	# Call the function by name
	call(function_name)
	
	# Hide UI and unpause
	hide()
	get_tree().paused = false
