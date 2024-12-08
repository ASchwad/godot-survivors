extends CanvasLayer

# Variable to track the previous state of the menu button
var was_menu_button_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var is_menu_button_pressed = Input.is_action_just_pressed("menu")
	var is_paused = get_tree().paused
	
	if is_menu_button_pressed:
		# Toggle the paused state
		get_tree().paused = not(is_paused)
