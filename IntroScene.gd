extends Node2D


@export var dialogue_resource : DialogueResource


@onready var Platter : Node2D = $PlatterScene
@onready var WiggleTimer : Timer = $WiggleTimer
@onready var DialogueTimer : Timer = $DialogueTimer

var stop_point : int = -10
var stop_point_reached : bool = false
var wiggle_count : int = 0


func _ready():
	Platter.lid_removed.connect(_on_lid_removed)


func _process(delta):
	check_stop_point()

	if stop_point_reached:
		Platter.set_state(Platter.MoveState.floating)

	else:
		Platter.set_state(Platter.MoveState.moving)


func check_stop_point():
	if Platter.position.y <= stop_point:
		stop_point_reached = true


func _on_wiggle_timer_timeout():
	Platter.wiggle()
	if wiggle_count < 3:
		wiggle_count += 1
		WiggleTimer.start(2)
	else:
		Platter.remove_lid()


func _on_lid_removed():
	stop_point = -50
	stop_point_reached = false
	Platter.top_hover_limit = -60
	Platter.bottom_hover_limit = -45
	DialogueTimer.start()


func _on_dialogue_timer_timeout():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, "intro")
