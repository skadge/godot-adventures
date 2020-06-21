extends Character

var key_given = false
var talking = false

func dialogue_stages():

    talking = true
    var sentences = ["Hello traveller, I'm Mermaida.",
                    "I've heard you're trying to help your village, thank you",
                    "I have this old beautiful key. It may unlock magical chests."]

    
    dialogue.say_many($Sprite, sentences) 
    yield(dialogue, "conversation_finished")
    player.obtain_master_key()
    
    sentences = ["I have this old beautiful key. It may unlock magical chests.",
                 "Hopefuly this will help you in your quest.",
                 "Good luck, traveller!",
                 ""]
    dialogue.say_many($Sprite, sentences) 
    yield(dialogue, "conversation_finished")
    dialogue.close()
    talking = false
    key_given = true
    
