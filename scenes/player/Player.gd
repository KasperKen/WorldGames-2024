extends CharacterBody2D


signal player_died


enum PlayerState{
	walking,
	attacking,
	idle
}


@export var health : float = 100.0
@export var speed : float = 100.0

@onready var PlayerAnimation : AnimationPlayer = $PlayerAnimation
@onready var Hitbox : Area2D = $Hitbox
@onready var Hurtbox : CollisionShape2D = $Hurtbox
@onready var PlayerSprite : Sprite2D = $PlayerSprite


const JUMP_VELOCITY = -400.0


var current_state
var current_direction : int = 1
var current_attack
var attack_finished : bool = true
var attack_list : Dictionary = {"jab": 30, "cross": 50}


func _ready():
	add_to_group("players")


func _physics_process(delta):
	velocity = Vector2(0,0)
	
	if not attack_finished: return
	
	if Input.is_action_pressed("ui_left"): velocity.x -= 1
	if Input.is_action_pressed("ui_right"): velocity.x += 1
	if Input.is_action_pressed("ui_up"): velocity.y -= 1
	if Input.is_action_pressed("ui_down"): velocity.y += 1
	
	if velocity.x != 0 or velocity.y != 0:
		current_state = PlayerState.walking

	elif Input.is_action_just_pressed("jab"):
		current_attack = "jab"
		current_state = PlayerState.attacking
	elif Input.is_action_just_pressed("cross"):
		current_attack = "cross"
		current_state = PlayerState.attacking

	else: current_state = PlayerState.idle
	
	
	match current_state:
		
		PlayerState.idle:
			PlayerAnimation.play("idle")

		PlayerState.walking:
			PlayerAnimation.play("walk")
			change_direction(velocity)
			velocity = velocity.normalized() * speed

		PlayerState.attacking:
			attack()
			velocity.x = 0

	move_and_slide()


func attack():
	attack_finished = false
	PlayerAnimation.play(current_attack)


func damage_enemy():
	var overlapping_bodies : Array = Hitbox.get_overlapping_bodies()
	var dmg = attack_list[current_attack]
	for enemy in overlapping_bodies:
		if enemy.has_method("take_damage"):
			enemy.take_damage(dmg)


func take_damage(dmg):
	health -= dmg
	if health <= 0: die()


func die():
	emit_signal("payer_died")
	queue_free()


func change_direction(dir):
	var x_dir = dir.x
	if current_direction == x_dir or x_dir == 0: return
	scale.x *= -1
	current_direction = x_dir


func _on_player_animation_animation_finished(animation_name):
	if animation_name in ["jab", "cross"]:
		damage_enemy()
		attack_finished = true
		
