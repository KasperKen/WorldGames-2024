extends Node2D


signal lid_removed


enum MoveState{
	floating,
	moving
}


@onready var PlatterTop : RigidBody2D = $PlatterContainer/PlatterTop
@onready var PlatterSFX : AudioStreamPlayer = $PlatterSFX


@export var float_speed : int = 1
@export var platter_hit_sounds : Array[Resource]


var move_state = MoveState
var default_x_speed : int = 0
var default_y_speed : int = 1
var current_y_speed : int = default_y_speed
var current_x_speed : int = default_x_speed
var top_hover_limit : int = -10
var bottom_hover_limit : int = 10


func _process(_delta):
	
	var velocity : Vector2
	var dampen_factor : int

	match move_state:

		MoveState.moving:
			current_y_speed = -default_y_speed
			velocity = Vector2(current_x_speed, current_y_speed)


		MoveState.floating:
			if position.y < top_hover_limit:
				current_y_speed = default_y_speed
			elif position.y > bottom_hover_limit:
				current_y_speed = -default_y_speed
				
			dampen_factor = 5
			velocity = Vector2(current_x_speed, current_y_speed) / dampen_factor

	translate(velocity)


func play_hit_sound(volume, pitch_low, pitch_high):
	PlatterSFX.stream = platter_hit_sounds.pick_random()
	PlatterSFX.volume_db = volume
	PlatterSFX.pitch_scale = randf_range(pitch_low, pitch_high)
	PlatterSFX.play()


func remove_lid():
	play_hit_sound(-10, 0.8, 1)
	PlatterTop.apply_impulse(Vector2(15,-55) * 15)
	emit_signal("lid_removed")


func wiggle():
	play_hit_sound(-20, 1, 1.5)
	PlatterTop.apply_impulse(Vector2(15, -15) * 5)


func set_state(new_state):
	move_state = new_state

