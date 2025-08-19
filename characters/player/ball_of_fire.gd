extends AnimatedSprite2D
var fireball_impact_effect = preload("res://fx/fire_ball_impact_effect.tscn")

var speed: int = 300
var direction: int 
var damage_amount = 1





func _physics_process(delta: float) -> void:
	move_local_x(direction * speed * delta)
	


func _on_animation_finished() -> void:
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Ball area entered")
	ball_impact()

func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Ball body entered")
	ball_impact()

func get_damage_amount() -> int:
	return damage_amount


func ball_impact():
	var fireball_impact_effect_instance = fireball_impact_effect.instantiate() as Node2D
	fireball_impact_effect_instance.global_position = global_position
	get_parent().add_child(fireball_impact_effect_instance)
	queue_free()
