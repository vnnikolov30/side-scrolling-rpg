extends Marker2D
var fireball_impact_effect = preload("res://fx/fire_ball_impact_effect.tscn")

var sword_attack = false
var jet_attack = false
var damage_amount = 1 if sword_attack else 2


func _on_sword_hitbox_area_entered(area: Area2D) -> void:
	sword_attack = true
	print("Sword area entered")
	sword_impact()


func _on_sword_hitbox_body_entered(body: Node2D) -> void:
	sword_attack = true
	print("Sword body entered")
	sword_impact()


func _on_flame_jet_hitbox_area_entered(area: Area2D) -> void:
	
	jet_attack = true
	print("Jet body entered")
	jet_impact()


func _on_flame_jet_hitbox_body_entered(body: Node2D) -> void:
	jet_attack = true
	print("Jet body entered")
	jet_impact()

func get_damage_amount() -> int:
	return damage_amount
	
func sword_impact():
	print("Sword impact anim")

func jet_impact():
	#var fireball_impact_effect_instance = fireball_impact_effect.instantiate() as Node2D
	#fireball_impact_effect_instance.global_position = global_position
	#get_parent().add_child(fireball_impact_effect_instance)
	#queue_free()
	print("Jet impact anim")
