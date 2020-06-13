extends "res://res/characters/Character.gd"

var is_first_time = true

func dialogue_stages():
    
    var sentences = []
    
    if is_first_time:
        sentences +=["I am the chief of this village"]
        is_first_time = false

        sentences += ["people in the village are feeling sick.",
                      "Help us find a cure.When you find it bring it to me!",
                      "The castle may know somthing about it."]
    dialogue.say_many($Sprite, sentences) 
