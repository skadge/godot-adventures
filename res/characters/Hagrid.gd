extends "res://res/characters/Character.gd"

var is_first_time = true

var moving = false

var speed_factor = 0.2

func _ready():
    get_node("..").unit_offset = 0.4

    dialogueDefault = ["I live in this cabin, you like it?",
                      "Those guards... I don't like them!",
                      "I hope the folks at the village will get better soon"]

    
func encounter_player():
    moving = true
    
func meeting_player_over():
    
    is_first_time = false
    
    $Timer.set_wait_time(2)
    $Timer.connect("timeout", self, "go_back_cabin")
    $Timer.start()

func go_back_cabin():
    moving = true
    speed_factor = -speed_factor
    
func dialogue_stages():
    
    var sentences = []
    
    if is_first_time:
        sentences +=["Heya",
                     "I'm Hagrid",
                     "I have a friend in the mountain",
                     "She might know... umph",
                     "She might know how to get you into the castle",
                     "Maybe?",
                     "Mountains are not far away, just keep walking East"]
        dialogue.say_many($Sprite, sentences)
        
        yield(dialogue, "conversation_finished") 
        
        meeting_player_over()
        
        
    else:

        # we are done with the pre-scripted dialogues; get a random line            
        dialogue.say($Sprite, default_dialogue())
    

func _process(delta):
    
    if moving:
        get_node("..").unit_offset += delta * speed_factor
        if get_node("..").unit_offset < 0.05:
            moving = false
