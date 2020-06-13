extends "res://res/characters/Character.gd"

onready var hagrid = get_node("../HagridPath/PathFollow2D/Hagrid")

var is_first_time = true
    
func dialogue_stages():
    
    var sentences = []
    
    if is_first_time:
        sentences += ["I'm the guard of the castle."]
        is_first_time = false

    sentences += ["Only the royal family can get in.",
                 "Go away!"]

    dialogue.say_many($Sprite, sentences, hagrid, "encounter_player") 

        
