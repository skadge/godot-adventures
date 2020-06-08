extends "res://res/characters/Character.gd"

var snowcatRideDone = true

signal ride_to_village

func dialogue_stages():

    if not snowcatRideDone:
        
        var sentences = []
        
        if is_first_time:
            sentences += ["I am the sorceress",
                "If you want to enter the castle, you need to fly over the walls",
                "I think...",
                "...the aeronaut...",
                "He lives at the Lonely Village and sells hot air balloons",
                "He might be able to help you."]

        sentences += ["The road to Lonely village is dangerous. Lots of monsters!",
                     " "]
                  
        dialogue.say_many($Sprite, sentences)
        yield(dialogue, "conversation_finished")
        dialogue.say_yes_no($Sprite, 
                    "Do you maybe want to ride my snowcat? She is faster than the monsters!",
                    self,
                    "on_yes_ride", 
                    "on_no_ride")

    else: # snowcat ride done, the sorceress now heals the wounds
        
        if player.health < 100:
            dialogue.say_yes_no($Sprite,
                                "For 2 coins, I can heal 5 health points.",
                                self,
                                "on_yes_healing",
                                "on_no_healing")
        else:
            dialogue.say($Sprite, "You are full of energy! I can not do anything for you right now.") 


func on_yes_ride():

    snowcatRideDone = true
    emit_signal("ride_to_village")

func on_no_ride():
    
    dialogue.say($Sprite, "Fine, but be careful with the monsters!\nAnd come back if you are wounded: I can heal you!")


func on_yes_healing():


    if player.gold >= 2:
        player.pay_out(2)
        player.health_change(5)
        
        dialogue.say($Sprite, "I have healed your wounds")

    else:
        dialogue.say($Sprite, "You do not have enough gold, unfortunately. Come back later!")
 

func on_no_healing():


    
    dialogue.say($Sprite, "Come and see me if you need to.")

