extends Area2D

'''
The Hurtbox is a util for any object with hp that we want to make disappear.
We can two-way bind signals and events from here.

This is currently used
'''

@export_enum("Cooldown", "HitOnce", "DisableHitbox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage)

func _on_area_entered(area: Area2D) -> void:
	print("entered")
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: # cooldown
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1: #HitOnce
					pass
				2: #DisableHitbox
					if area.has_method("temp_disable"):
						area.temp_disable()
			var damage = area.damage
			emit_signal("hurt", damage)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1);
		else:
			print("EMITTING")
			emit_signal("hurt", 2)


func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)
