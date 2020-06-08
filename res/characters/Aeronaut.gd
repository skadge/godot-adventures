extends "res://res/characters/Character.gd"

onready var hotairballoon  = root.get_node("Game/Items/HotAirBalloon")

var is_first_time = true

var balloonSold = false

signal hotAirBalloonAvailable

func _init():
    dialogues = ["Hello, I am the aeronaut.",
                 "Welcome to my shop! I sell hot air balloons for 25 coins.",
                 "would you like to buy?"
                ]
                
    dialogueDefault = ["I love to fly!", 
                       "Have you ever dreamt of being a bird?"]


func dialogue_stages():

    if not balloonSold:
        
        var sentences = dialogues
        
        if is_first_time:
            is_first_time = false
        else:
            sentences = dialogues.slice(1, dialogues.size()-1)
        
            
        dialogue.say_many($Sprite, sentences)
        yield(dialogue, "conversation_finished")
        dialogue.say_yes_no($Sprite, 
                    dialogues[2],
                    self,
                    "on_yes_buy_balloon", 
                    "on_no_buy_balloon")

    else:
        # we are done with the pre-scripted dialogues; get a random line            
        dialogue.say($Sprite, default_dialogue())
        
            
func on_yes_buy_balloon():

    if player.gold >= 25:
        player.pay_out(25)
        
        var tween = root.get_node("Game/Tween")
        tween.interpolate_property(hotairballoon, "position",
        hotairballoon.position, player.position + Vector2(0,64), 1,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        tween.start()
        
        tween.interpolate_property(hotairballoon, "modulate:a",
        1, 0, 1,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        tween.start()
        
        emit_signal("hotAirBalloonAvailable")
        dialogue.say($Sprite, "Great! Here your hot air balloon! Have a safe ride!")
        balloonSold = true
    else:
        dialogue.say($Sprite, "You do not have enough gold, unfortunately. Come back later!")
           

func on_no_buy_balloon():
    
    dialogue.say($Sprite, "That's a pity. Maybe another time?")
