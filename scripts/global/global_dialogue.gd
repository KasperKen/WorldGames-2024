extends Node


enum DialogueState{
	intro,
	give_Y,
	explain_Y
}


var intro_dialogue_finished : bool = false
var explain_Y_dialogue_finished : bool = false
var dialogue_state = DialogueState.intro


func set_state(new_state):
	dialogue_state = new_state


func get_state():
	match dialogue_state:
		
		DialogueState.intro:
			return "intro"
			
		DialogueState.give_Y:
			return "give_Y"
			
		DialogueState.explain_Y:
			return "explain_Y"
