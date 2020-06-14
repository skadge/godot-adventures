extends Character

var fluteGiven = false
var is_first_time = true

signal fluteGiven

func _init():
        
    dialogueDefault = ["I love playing in the castle's courtyard", 
                       "There is not many children to play with here..."]


func dialogue_stages():

    var sentences = []
    
    if is_first_time:
        sentences = ["Hi! I'm Nobby! I'm 7!",
                     "I love apples!",
                    "If you give me 5 apples, I'll give you a surprise!"]
        dialogue.say_many($Sprite, sentences) 
        yield(dialogue, "conversation_finished")
        is_first_time = false

                
    if not fluteGiven:
   
        
        dialogue.say_yes_no($Sprite, 
                    "If you give me 5 apples, I'll give you a surprise!",
                    self,
                    "on_yes", 
                    "on_no")

    else:
        # we are done with the pre-scripted dialogues; get a random line            
        dialogue.say($Sprite, default_dialogue())
        

func on_yes():

    if player.apple >= 5:
        player.apple_changed(-5)
        
        emit_signal("fluteGiven")
        dialogue.say($Sprite, "Thank you for the apple! I give you my flute! You can play music with it.")
        fluteGiven = true
    else:
        dialogue.say($Sprite, "You don't have 5 apples!")
  

func on_no():

    dialogue.say($Sprite, "Ok, but please bring me apples next time!")

