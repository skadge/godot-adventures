extends Character

var is_first_time = true

func _ready():
    dialogueDefault = ["I have heard of this magic fruit... long lost I fear!",
                       "I am sorry, I can not help you more"]
func dialogue_stages():
    
    var sentences = []
    
    if is_first_time:
        sentences += ["Ahem ahem... Who are you to enter my castle in such a way?",
                      "I shall replace my guard. He does not know how to do his duty",
                      "I see... you are looking for something to heal your village?",
                      "I have heard of this magic fruit... long lost I fear!",
                      "I am sorry, but that is all I can do to help you"
                      ]
        

        dialogue.say_many($Sprite, sentences)
    
    
        yield(dialogue, "conversation_finished")
        is_first_time = false
    
    else:
        # we are done with the pre-scripted dialogues; get a random line            
        dialogue.say($Sprite, default_dialogue())
