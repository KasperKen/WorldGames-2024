extends Node2D

@onready var PlatterTop : RigidBody2D = $PlatterTop

# Called when the node enters the scene tree for the first time.
func _ready():
	remove_lid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func remove_lid():
	PlatterTop.apply_impulse(Vector2(20,-20) * 20)
