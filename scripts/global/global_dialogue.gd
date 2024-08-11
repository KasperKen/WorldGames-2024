extends Node


enum DialogueState{
	intro,
	give_x,
	explain_x
}


var intro_dialogue_finished : bool = false
var explain_x_dialogue_finished : bool = false
var dialogue_state = DialogueState.intro


func set_state(new_state):
	dialogue_state = new_state


func get_state():
	match dialogue_state:
		
		DialogueState.intro:
			return "intro"
			
		DialogueState.give_x:
			return "give_x"
			
		DialogueState.explain_x:
			return "explain_x"
