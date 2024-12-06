extends CharacterBody2D

@export var movement_speed = 20
@export var hp = 10
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")

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


func _on_hurtbox_hurt(damage: Variant) -> void:
	hp -= damage
	if hp <= 0:
		queue_free()
