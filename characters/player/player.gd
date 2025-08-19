extends CharacterBody2D
var fireball = preload("res:///characters/player/ball_of_fire.tscn")
const GRAVITY = 1000
@export var speed: int = 300
@export var jump: int = -300
@export var jump_horizontal: int = 100
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle
@onready var collision_shape_sword: CollisionShape2D = $HitboxPivot/SwordHitbox/CollisionShape2D2
@onready var collision_shape_flamejet: CollisionShape2D = $HitboxPivot/FlameJetHitbox/CollisionShape2D2
@onready var hitbox_pivot: Marker2D = $HitboxPivot


enum State {Idle, Run, Jump, Shoot, Attack,FireJet}
var current_state : State
var character_sprite : Sprite2D
var muzzle_position

var player_attack_anims_list: Array[String] = ["sword_strike", "fireball", "flamejet"]


func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position
	collision_shape_sword.set_deferred("disabled", true)
	collision_shape_flamejet.set_deferred("disabled", true)
	


#func get_player_type():
	#return "player"  


func _physics_process(delta: float) -> void:
	
	
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_muzzle_position()
	player_shooting(delta)
	player_attack(delta)
	player_fire_jet(delta)
	move_and_slide()
	player_animations()
	
func is_attacking() -> bool:
	return current_state in [State.Attack, State.Shoot, State.FireJet]

func player_falling(delta):
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func player_idle(delta):
	if current_state in [State.Attack, State.Shoot, State.FireJet]:
		return
	if is_on_floor():
		current_state = State.Idle

func player_run(delta):
	if is_attacking():
		velocity.x = 0
		return
	if current_state in [State.Attack, State.Shoot, State.FireJet]:
		return
	var direction = input_movement()
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = direction < 0
		hitbox_pivot.scale.x = -1 if direction < 0 else 1


func player_jump(delta:float):
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump
		current_state = State.Jump
		
	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal * delta
		hitbox_pivot.scale.x = -1 if direction < 0 else 1

func player_shooting(delta:float):
	if is_attacking():
		return
	var direction = input_movement()
	if  Input.is_action_just_pressed("shoot"):
		var firball_instance = fireball.instantiate() as Node2D
		firball_instance.direction = direction
		firball_instance.global_position = muzzle.global_position
		get_parent().add_child(firball_instance)
		current_state = State.Shoot

func player_fire_jet(delta:float):
	if is_attacking():
		return
	var direction = input_movement()
	if  Input.is_action_just_pressed("fire_jet"):
		collision_shape_flamejet.set_deferred("disabled", false)
		current_state = State.FireJet


func player_attack(delta:float):
	
	var direction = input_movement()
	if  Input.is_action_just_pressed("attack"):
		collision_shape_sword.set_deferred("disabled", false)
		current_state = State.Attack
		

func player_muzzle_position():
	var direction = input_movement()
	if direction > 0:	
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x

func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	
	
	elif current_state == State.Run and animated_sprite_2d.animation not in  player_attack_anims_list:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
	elif current_state == State.Shoot:
		animated_sprite_2d.play("fireball")
	elif current_state == State.Attack:
		animated_sprite_2d.play("sword_strike")
	elif current_state == State.FireJet:
		animated_sprite_2d.play("flamejet")
		

func input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation in player_attack_anims_list:
		collision_shape_sword.set_deferred("disabled", true)
		collision_shape_flamejet.set_deferred("disabled", true)
		current_state = State.Idle
		animated_sprite_2d.play("idle")
