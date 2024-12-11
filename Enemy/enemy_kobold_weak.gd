extends CharacterBody2D

@export var movement_speed = 20
@export var hp = 10
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sound_hit = $sound_hit


var death_animation = preload("res://Enemy/explosion.tscn")

func _ready():
	animation.play("Walk")

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.y >0:
		sprite.flip_h = false
	
	move_and_slide()

func death():
	var enemy_death : Sprite2D = death_animation.instantiate()
	enemy_death.scale = sprite.scale
	enemy_death.global_position  = global_position
	get_parent().call_deferred("add_child", enemy_death)
	queue_free()

func _on_hurtbox_hurt(damage: Variant) -> void:
	sound_hit.play()
	hp -= damage
	if hp <= 0:
		death()
		await get_tree().create_timer(0.1).timeout
		queue_free()
