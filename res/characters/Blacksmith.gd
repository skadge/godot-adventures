extends "res://res/characters/Character.gd"

var swordSold = false
var is_first_time = true

signal swordAvailable

func _init():
    dialogues = ["Hi I am Bilbo the blacksmith of this village",
                 "There are a lot of monsters in the forest so you might do with a sword or two",
                 "Would you like a sword? It costs 7 coins."
                ]
                
    dialogueDefault = ["I like soot", 
                       "Have you ever dreamed of making a sword?"]



func dialogue_stages():

    if not swordSold:
        
        if is_first_time:
            is_first_time = false
            dialogue.say_many($Sprite, dialogues) 
            yield(dialogue, "conversation_finished")
            
        dialogue.say_yes_no($Sprite, 
                    dialogues[2],
                    self,
                    "on_yes_buy_sword", 
                    "on_no_buy_sword")

    else:
        # we are done with the pre-scripted dialogues; get a random line            
        dialogue.say($Sprite, default_dialogue())
        

func on_yes_buy_sword():

    if player.gold >= 7:
        player.pay_out(7)
        
        emit_signal("swordAvailable")
        dialogue.say($Sprite, "Here your sword! Thank you for shopping")
        swordSold = true
    else:
        dialogue.say($Sprite, "You do not have enough gold, unfortunately. Come back later!")
  

func on_no_buy_sword():

    dialogue.say($Sprite, "That's a pity. Maybe another time?")

