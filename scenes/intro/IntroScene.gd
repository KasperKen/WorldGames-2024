extends Node2D


signal scene_ended


@export var dialogue_resource : DialogueResource


@onready var PlatterScene : Node2D = $PlatterScene
@onready var PlatterContainer : Node2D = $PlatterScene/PlatterContainer
@onready var WiggleTimer : Timer = $WiggleTimer
@onready var DialogueTimer : Timer = $DialogueTimer
@onready var YPower : PackedScene = load("res://scenes/Y_power/Y_power.tscn")
@onready var YSpawnPoint : Marker2D = $PlatterScene/YSpawnPoint
@onready var ScreenCenter : Marker2D = $ScreenCenter
@onready var EndSceneTimer : Timer = $EndSceneTimer


var stop_point : int = -10
var stop_point_reached : bool = false
var wiggle_count : int = 0
var entities_despawned : bool = false
var y_spawned : bool = false
var spawned_y_scene
var end_scene_timer_started = false


func _ready():
	PlatterScene.lid_removed.connect(_on_lid_removed)


func _process(_delta):
	check_stop_point()

	if GlobalDialogue.intro_dialogue_finished and not y_spawned:
		spawn_y_power()
		GlobalDialogue.set_state(GlobalDialogue.DialogueState.explain_Y)
		DialogueTimer.start()

	if GlobalDialogue.explain_Y_dialogue_finished and not entities_despawned:
		despawn_platter()
		scale_y(3, 3, 2.0)
		var y_speed = 1
		var target_position = ScreenCenter.position
		var y_direction : Vector2 = (target_position - spawned_y_scene.position).normalized()
		var y_velocity = y_direction * y_speed

		if spawned_y_scene.position.distance_to(target_position) > 1:
			spawned_y_scene.position += y_velocity

		else:
			start_end_scene_timer() 


	if stop_point_reached:
		PlatterScene.set_state(PlatterScene.MoveState.floating)

	else:
		PlatterScene.set_state(PlatterScene.MoveState.moving)


func check_stop_point():
	if PlatterScene.position.y <= stop_point:
		stop_point_reached = true


func spawn_y_power():
	spawned_y_scene = YPower.instantiate()
	spawned_y_scene.position = YSpawnPoint.position
	PlatterScene.add_child(spawned_y_scene)
	y_spawned = true


func despawn_platter():
	var tween = create_tween()
	tween.tween_property(PlatterContainer, "modulate", Color.TRANSPARENT, 1.0)


func scale_y(x_size, y_size, time):
	var tween = create_tween()
	tween.tween_property(spawned_y_scene, "scale", Vector2(x_size, y_size), time)


func start_end_scene_timer():
	if not end_scene_timer_started:
		end_scene_timer_started = true
		EndSceneTimer.start()


func _on_wiggle_timer_timeout():
	if wiggle_count < 3:
		PlatterScene.wiggle()
		wiggle_count += 1
		WiggleTimer.start(2)
	else:
		PlatterScene.remove_lid()


func _on_lid_removed():
	stop_point = -50
	stop_point_reached = false
	PlatterScene.top_hover_limit = -60
	PlatterScene.bottom_hover_limit = -45
	DialogueTimer.start()


func _on_dialogue_timer_timeout():
	var dialogue_title = GlobalDialogue.get_state()
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_title)


func _on_end_scene_timer_timeout():
	var tween = create_tween()
	tween.tween_property(spawned_y_scene, "modulate", Color.TRANSPARENT, 1.0)
	await(tween.finished)
	#end scene
