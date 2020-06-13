extends "res://res/characters/Character.gd"

onready var hagrid = get_node("../HagridPath/PathFollow2D/Hagrid")

var is_first_time = true
    
func dialogue_stages():
    
    var sentences = []
    
    if is_first_time:
        sentences += ["I'm the guard of the castle."]
        

    sentences += ["Only the royal family can get in.",
                 "Go away!"]

    dialogue.say_many($Sprite, sentences)
    
    if is_first_time:
        yield(dialogue, "conversation_finished")
        hagrid.encounter_player()
        is_first_time = false

        
