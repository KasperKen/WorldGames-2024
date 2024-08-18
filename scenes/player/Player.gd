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
@onready var Hurtbox : CollisionShape2D = $Hurtbox
@onready var PlayerSprite : Sprite2D = $PlayerSprite


const JUMP_VELOCITY = -400.0


var current_state
var current_direction : int = 1
var current_attack
var attack_finished : bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	add_to_group("players")


func _physics_process(delta):
	
	if not attack_finished: return
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if direction: current_state = PlayerState.walking
	
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
			velocity.x = 0

		PlayerState.walking:
			print_debug("walking")
			PlayerAnimation.play("walk")
			change_direction(direction)
			velocity.x = direction * speed

		PlayerState.attacking:
			attack_finished = false
			PlayerAnimation.play(current_attack)
			velocity.x = 0

	move_and_slide()


func take_damage(dmg):
	health -= dmg
	if health >= 0: die()


func die():
	emit_signal("payer_died")
	queue_free()


func change_direction(dir):
	if current_direction != dir:
		Hurtbox.position.x *= -1
		current_direction = dir
		PlayerSprite.scale.x = dir


func _on_player_animation_animation_finished(anim_name):
	if anim_name in ["jab", "cross"]: attack_finished = true
