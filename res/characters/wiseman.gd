extends "res://res/characters/Character.gd"

var is_first_time = true

func dialogue_stages():
    
    var sentences = []
    
    if is_first_time:
        sentences +=["I am the chief of this village"]
        is_first_time = false

    if player.golden_pineapple_available:
        sentences = ["You brought back the mythical Golden Pineapple!",
                     "I had heard of this magical fruit, but I thought it was a legend!",
                     "You are a hero!!",
                     "This will cure the village, no doubt about it!",
                     "Thank you so much!!"]
    else:
        sentences += ["people in the village are feeling sick.",
                        "Help us find a cure.When you find it bring it to me!",
                        "The castle may know something about it."]
    dialogue.say_many($Sprite, sentences) 
