extends Node2D
class_name Character

onready var root = get_tree().root
onready var dialogue  = root.get_node("Game/DialoguesLayer/Dialogues")

onready var player  = root.get_node("Game/Items/Player")

# Declare member variables here. Examples:
var dialogueStage = 0
var dialogues = ["Default dialogue 1.",
                 "Default dialogue 2.",
                "Default dialogue 3."
                ]
                
var dialogueDefault = ["How are you today?", 
                       "What a lovely weather!"]



var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    rng.randomize()
    connect_signals()
    
func connect_signals():
    connect("body_entered", self, "_on_Character_body_entered")
    connect("body_exited", self, "_on_Character_body_exited")

# to be overriden for each different character
func dialogue_stages():

    if true:
        
        var sentences = dialogues
        
            
        dialogue.say_many($Sprite, sentences)
        yield(dialogue, "conversation_finished")
        dialogue.say_yes_no($Sprite, 
                    dialogues[2],
                    self,
                    "on_yes", 
                    "on_no")

    else:
        # we are done with the pre-scripted dialogues; get a random line            
        dialogue.say($Sprite, default_dialogue())
        
            

func on_yes():

    if player.gold >= 7:
        player.pay_out(7)
        
        #emit_signal("swordAvailable")
        dialogue.say($Sprite, "Yes!!")

    else:
        dialogue.say($Sprite, "You do not have enough gold, unfortunately. Come back later!")
  

func on_no():

    dialogue.say($Sprite, "That's a pity. Maybe another time?")



func default_dialogue():
    var idx = rng.randi_range(0, dialogueDefault.size() - 1)
    return dialogueDefault[idx]
    
func _on_Character_body_entered(body):
    
    if body.get_name() == "Player":
        dialogue_stages()



    

func _on_Character_body_exited(_body):
        
    dialogue.close()

    
