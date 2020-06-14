extends Character

var is_first_time = true

func _ready():
    pass
    
func dialogue_stages():
    
    var sentences = []
    
    if is_first_time:
        sentences += ["I am the queen of Purdownia"]
        is_first_time = false
    
    sentences += [
                    "I have heard of the legend of a mythical ocean creature",
                    "Only music would summon it to you",
                    "But it is only a legend!"
                ]
        

    dialogue.say_many($Sprite, sentences)
    
