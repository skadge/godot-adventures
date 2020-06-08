extends "res://res/characters/Character.gd"


func dialogue_stages():
    
    var sentences = []
    
    if is_first_time:
        sentences += ["I'm the guard of the castle."]

    sentences += ["Only the royal family can get in.",
                 "Go away!"]

    dialogue.say_many($Sprite, sentences) 

        
