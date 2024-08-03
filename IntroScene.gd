extends Node2D


@onready var Platter : Node2D = $PlatterScene
@onready var WiggleTimer : Timer = $WiggleTimer


var stop_point : int = 10
var stop_point_reached : bool = false
var wiggle_count : int = 0


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
