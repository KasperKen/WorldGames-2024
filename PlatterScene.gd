extends CharacterBody2D


@onready var PlatterTop : RigidBody2D = $PlatterTop


enum MoveState{
	floating,
	moving
}


@export var float_speed : int = 1


var move_state = MoveState
var default_x_speed : int = 0
var default_y_speed : int = 1
var current_y_speed : int = default_y_speed
var current_x_speed : int = default_x_speed



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var velocity : Vector2
	var dampen_factor : int

	match move_state:

		MoveState.moving:
			current_y_speed = -default_y_speed
			velocity = Vector2(current_x_speed, current_y_speed)


		MoveState.floating:
			if position.y < 0:
				current_y_speed = default_y_speed
			elif position.y > 20:
				current_y_speed = -default_y_speed
				
			dampen_factor = 5
			velocity = Vector2(current_x_speed, current_y_speed) / dampen_factor
	
	
	move_and_collide(velocity)


func remove_lid():
	PlatterTop.apply_impulse(Vector2(15,-55) * 15)


func wiggle():
	print_debug("wiggling")
	PlatterTop.apply_impulse(Vector2(15, -15) * 5)


func set_state(new_state):
	move_state = new_state
