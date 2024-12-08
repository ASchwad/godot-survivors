extends CharacterBody2D
@onready var sprite = $Sprite2D
@onready var walk_timer = $WalkTimer

var movement_speed = 60.0
var player_index = 0
@export var hp = 80

# Attacks
var icespear = preload("res://Player/Attack/icespear.tscn")

@onready var icespearTimer : Timer = get_node("Attack/IcespearTimer")
@onready var icespearAttackTimer : Timer = get_node("Attack/IcespearTimer/IcespearAttackTimer")

var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_attackspeed = 1.5
var icespear_level = 1

var enemy_close = []

func _ready():
	attack()

func attack():
	if icespear_level > 0:
		icespearTimer.wait_time = icespear_attackspeed
		if icespearTimer.is_stopped():
			icespearTimer.start()


func _physics_process(delta: float) -> void:
	movement()
	
func movement():
	# var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	# var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	# var mov = Vector2(x_mov, y_mov)
	# velocity = mov.normalized()*movement_speed
	var direction = Input.get_vector("left","right","up","down")
	var sprint_active = true if Input.get_action_strength("sprint") == 1.0 else false
		
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
			
	
	velocity = direction * movement_speed * (3 if sprint_active else 1)
	move_and_slide()

func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	Input.start_joy_vibration(player_index, 0.1, 0.3, 0.2)
	print(hp)

# Like loading ammunition
func _on_icespear_timer_timeout() -> void:
	icespear_ammo += icespear_baseammo
	icespearAttackTimer.start()

# Individual shot
func _on_icespear_attack_timer_timeout() -> void:
	if icespear_ammo > 0:
		var icespear_attack = icespear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_closest_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			icespearAttackTimer.start()
		else:
			icespearAttackTimer.stop()
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func get_closest_target():
	var closest_enemy = null
	if enemy_close.size() > 0:
		var shortest_distance = INF
		for enemy in enemy_close:
			var distance = position.distance_to(enemy.global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				closest_enemy = enemy
	return closest_enemy.global_position if closest_enemy else Vector2.UP


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
