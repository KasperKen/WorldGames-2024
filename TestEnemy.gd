extends CharacterBody2D


enum EnemyState{
	wandering,
	chasing,
	attacking,
	idle
}


@export var health : float = 100.0
@export var speed : float = 100.0




const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var players : Array = []


func _ready():
	add_to_group("enemies")
	players = get_tree().get_nodes_in_group("players")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
