extends CharacterBody2D
@onready var sprite = $Sprite2D
@onready var walk_timer = $WalkTimer

var movement_speed = 60.0
@export var hp = 80

func _physics_process(delta: float) -> void:
	movement()
	
func movement():
	# var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	# var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	# var mov = Vector2(x_mov, y_mov)
	# velocity = mov.normalized()*movement_speed
	var direction = Input.get_vector("left","right","up","down")
	
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
		
	if direction != Vector2.ZERO:
		if walk_timer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walk_timer.start()
	velocity = direction * movement_speed
	move_and_slide()

func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)
