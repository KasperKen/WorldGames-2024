extends CharacterBody2D


enum EnemyState{
	wandering,
	chasing,
	attacking,
	idle
}


@export var health : float = 100.0
@export var speed : float = 1.0


@onready var players : Array = get_tree().get_nodes_in_group("players")
@onready var EnemyAnimation : AnimationPlayer = $EnemyAnimation
@onready var Hitbox : Area2D = $Hitbox


var attacks : Dictionary = {"jab": 30, "cross": 50}
var enemy_state
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target : CharacterBody2D
var current_direction : int = 1
var attack_finished : bool = true
var current_attack : String


func _ready():
	add_to_group("enemies")
	enemy_state = EnemyState.chasing

func _physics_process(delta):
	velocity = Vector2(0,0)
	
	match enemy_state:
		
		EnemyState.chasing:
			var target_player = players.pick_random()
			var direction = global_position.direction_to(target_player.global_position)
			direction.x = format_x_vector(direction.x)
			change_direction(direction)
			if (target_player.global_position - global_position).length() > 30: 
				velocity = direction * speed
				EnemyAnimation.play("walk")
			else: enemy_state = EnemyState.attacking
			
		EnemyState.attacking:
			if attack_finished: attack()
			
	move_and_collide(velocity)


func attack():
	attack_finished = false
	current_attack = attacks.keys().pick_random()
	EnemyAnimation.play(current_attack)


func take_damage(dmg):
	health -= dmg
	if health <= 0: queue_free()


func damage_enemy():
	var bodies = Hitbox.get_overlapping_bodies()
	for body in bodies:
		if not body.has_method("take_damage"):
			continue
		body.take_damage(attacks[current_attack])
		
		
func format_x_vector(x_vector):
	var new_vector : float
	if x_vector > 0 : new_vector = 1.0
	elif x_vector < 0 : new_vector = -1.0
	return new_vector


func change_direction(dir):
	var x_dir = dir.x
	if current_direction == x_dir or x_dir == 0: return
	scale.x *= -1
	current_direction = x_dir


func _on_enemy_animation_animation_finished(animation_name):
	if animation_name in ["jab", "cross"]:
		damage_enemy()
		attack_finished = true
